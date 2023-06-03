//
//  SearchResultsView.swift
//  CarPool
//
//  Created by Himanshu on 5/26/23.
//

import SwiftUI

struct SearchResultsView: View {
    
    // MARK: - properties
    
    // variable tp navigate to rides details view
    @State var navigate = false
    
    // variable to contain current clicked or default value
    // of data related to search model
    @State var selectedTile: Datum?
    
    // environment object for search view model
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            // app bar at the top
            ZStack(alignment: .leading) {
                
                // button to pop view
                Button(action: {
                    searchViewModel.showSearchResults.toggle()
                }, label: {
                    Image(systemName: Constants.Icon.back)
                })
                
                HStack {
                    Text(searchViewModel.startLocation)
                        .frame(width: 40)
                        .truncationMode(.tail)
                    Image(systemName: Constants.Icon.arrowsLeftRight)
                        .font(.system(size: 12))
                    Text(searchViewModel.endLocation)
                    
                        .frame(width: 40)
                        .truncationMode(.tail)
                }
                .padding(.horizontal, 44)
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
            .environmentObject(SearchViewModel())
    }
}
