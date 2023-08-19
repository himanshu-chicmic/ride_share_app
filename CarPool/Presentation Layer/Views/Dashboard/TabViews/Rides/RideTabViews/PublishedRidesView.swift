//
//  PublishedRidesView.swift
//  CarPool
//
//  Created by Himanshu on 6/28/23.
//

import SwiftUI

struct PublishedRidesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    // data of selected result
    @State var selectedTile: Publish?
    
    var body: some View {
        VStack {
            if !searchViewModel.publishedRidesData.isEmpty {
                ScrollView {
                    ForEach($searchViewModel.publishedRidesData, id: \.id) { $data in
                        RidesListItem(
                            startLoction    : data.source,
                            startTime       : "\(Formatters.getFormattedDate(date: data.time)) • \(String(describing: data.date ?? Constants.ErrorsMessages.noDate))",
                            endLocation     : data.destination,
                            endTime         : Formatters.getFormattedDate(date: data.estimateTime),
                            date            : "\(data.date ?? Constants.Placeholders.defaultTime)",
                            price           : Formatters.getPrice(price: Int(data.setPrice)),
                            seats           : data.passengersCount,
                            rideStatus: Helpers.getRideStatus(status: data.status.lowercased())
                        )
                        .foregroundColor(.black)
                        .onTapGesture {
                            selectedTile = data
                            searchViewModel.searchItemClicked(data: data)
                            searchViewModel.showPublishedRideView.toggle()
                        }
                    }
                    .navigationDestination(isPresented: $searchViewModel.showPublishedRideView) {
                        PublishedRideView(data: selectedTile ?? nil)
                            .navigationBarBackButtonHidden()
                    }
                    .padding()
                }
                .refreshable {
                    searchViewModel.sendRequestToGetPublished(httpMethod: .GET, requestType: .publishedRides, data: [:])
                }
            } else {
                PlaceholderView(image: Constants.EmptyRidesView.image, title: Constants.EmptyRidesView.title, caption: Constants.EmptyRidesView.caption)
            }
        }.onAppear {
            if BaseViewModel.shared.switchToDashboard {
                searchViewModel.sendRequestToGetPublished(httpMethod: .GET, requestType: .publishedRides, data: [:])
            }
        }
    }
}

struct PublishedRidesView_Previews: PreviewProvider {
    static var previews: some View {
        PublishedRidesView()
            .environmentObject(SearchViewModel())
    }
}
