//
//  SearchResultsView.swift
//  CarPool
//
//  Created by Himanshu on 5/26/23.
//

import SwiftUI

struct SearchResultsView: View {
    
    // MARK: - properties
    
    // variable to contain current clicked or default value
    // of data related to search model
    @State var selectedTile: Datum?
    
    // environment object for search view model
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            // app bar
            HStack {
                
                // back button
                Button(action: {
                    searchViewModel.showSearchResults.toggle()
                }, label: {
                    Image(systemName: Constants.Icon.back)
                })
                
                VStack (alignment: .leading, spacing: 4) {
                    HStack {
                        Text(searchViewModel.startLocation)
                        Image(systemName: Constants.Icon.arrowLeft)
                        Text(searchViewModel.endLocation)
                        
                        Spacer()
                    }
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.system(size: 13))
                    
                    Text(String(format: Constants.Search.searchBarCaption, Globals.dateFormatter.string(from: searchViewModel.dateOfDeparture), searchViewModel.numberOfPersons))
                    .fontWeight(.light)
                    .font(.system(size: 12))
                }
                .frame(maxWidth: .infinity)
                .padding(.leading)
                
                // filter button
                Button(action: {
                    // toggle filter view
                }, label: {
                    Image(systemName: Constants.Icon.filters)
                })
            }
            .padding(22)
            .padding(.horizontal, 4)
            .overlay {
                RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                    .stroke()
                    .foregroundColor(.gray.opacity(0.5))
                    .padding(8)
            }
            
            ScrollView {
                
                ForEach($searchViewModel.searchResults, id: \.self) { $data in
                    RidesListItem(
                        startLoction    : data.publish.source,
                        startTime       : Globals.getFormattedDate(date: data.publish.time),
                        endLocation     : data.publish.destination,
                        endTime         : Globals.getFormattedDate(date: data.reachTime),
                        date            : "\(data.publish.date ?? Constants.Placeholders.defaultTime)",
                        price           : Globals.getPrice(price: data.publish.setPrice),
                        driverImage     : data.imageURL ?? "",
                        driverName      : data.name,
                        driverRating    : Globals.getRatings(ratings: data.averageRating ?? 0)
                    )
                    .foregroundColor(.black)
                    .onTapGesture {
                        selectedTile = data
                        searchViewModel.showRideDetailView.toggle()
                    }
                }
                .navigationDestination(isPresented: $searchViewModel.showRideDetailView) {
                    RideDetailView(data: selectedTile ?? nil)
                        .navigationBarBackButtonHidden()
                }
                .padding()
                
            }
        }
        .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView()
            .environmentObject(SearchViewModel())
    }
}
