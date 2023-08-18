//
//  BookedRidesView.swift
//  CarPool
//
//  Created by Himanshu on 6/29/23.
//

import SwiftUI

struct BookedRidesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    // data of selected result
    @State var selectedTile: BookedRidesData?
    
    var body: some View {
        VStack {
            if !searchViewModel.bookedRidesData.isEmpty {
                ScrollView {
                    ForEach($searchViewModel.bookedRidesData, id: \.bookingID) { $data in
                        RidesListItem(
                            startLoction    : data.ride.source,
                            startTime       : "\(Formatters.getFormattedDate(date: data.ride.time)) • \(String(describing: data.ride.date ?? Constants.ErrorsMessages.noDate))",
                            endLocation     : data.ride.destination,
                            endTime         : Formatters.getFormattedDate(date: data.reachTime),
                            date            : "\(data.ride.date ?? Constants.Placeholders.defaultTime)",
                            price           : Formatters.getPrice(price: Int(data.ride.setPrice)),
                            seats : data.seat,
                            rideStatus: Helpers.getRideStatus(status: data.status.lowercased())
                        )
                        .foregroundColor(.black)
                        .onTapGesture {
                            selectedTile = data
                            searchViewModel.searchItemClicked(data: data)
                        }
                    }
                    .navigationDestination(isPresented: $searchViewModel.showRideDetailView) {
                        RideDetailView(data: selectedTile ?? nil)
                            .navigationBarBackButtonHidden()
                    }
                    .padding()
                }
            } else {
                PlaceholderView(image: Constants.EmptyRidesView.image, title: Constants.EmptyRidesView.title, caption: Constants.EmptyRidesView.caption)
            }
        }.onAppear{
            if BaseViewModel.shared.switchToDashboard {
                searchViewModel.sendRequestToGetBooked(httpMethod: .GET, requestType: .bookedRides, data: [:])
            }
        }
    }
}

struct BookedRidesView_Previews: PreviewProvider {
    static var previews: some View {
        BookedRidesView()
            .environmentObject(SearchViewModel())
    }
}
