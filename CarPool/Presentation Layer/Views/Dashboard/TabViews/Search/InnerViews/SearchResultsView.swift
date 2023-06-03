//
//  SearchResultsView.swift
//  CarPool
//
//  Created by Nitin on 5/26/23.
//

import SwiftUI

struct SearchResultsView: View {
    
    @State var navigate = false
    
    @State var selectedTile: Datum?
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // app bar at the top
            ZStack(alignment: .leading) {
                
                // button to pop view
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Constants.Icon.back)
                })

                // title for app bar
                Text("Ride Details")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            
            ScrollView {
                ForEach($searchViewModel.searchResults, id: \.self) { $data in
                    RidesListItem(
                        startLoction    : data.publish.source,
                        startTime       : data.publish.time,
                        endLocation     : data.publish.destination,
                        endTime         : data.publish.time,
                        price           : "String(data.publish.setPrice)",
                        dateOfDeparture : "data.publish.date",
                        numberOfSeats   : "data.publish.passengersCount",
                        driverImage     : Constants.Images.introImage,
                        driverName      : "data.publish.d",
                        driverRating    : "String(data.averageRating)"
                    )
                    .foregroundColor(.black)
                    .onTapGesture {
                        navigate.toggle()
                    }
                }
                .navigationDestination(isPresented: $navigate) {
                    RideDetailView(data: selectedTile ?? nil)
                        .navigationBarBackButtonHidden()
                }
                .padding()
                
            }
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
    }
}
