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
                            rideStatus: Helpers.getRideStatus(status: data.status.lowercased())
                        )
                        .foregroundColor(.black)
                        .onTapGesture {
                            selectedTile = data
                                searchViewModel.showPublishedRideView.toggle()
                            searchViewModel.searchItemClicked(data: data)
                        }
                    }
                    .navigationDestination(isPresented: $searchViewModel.showPublishedRideView) {
                        PublishedRideView(data: selectedTile ?? nil)
                            .navigationBarBackButtonHidden()
                    }
                    .padding()
                }
            } else {
                PlaceholderView(image: Constants.EmptyRidesView.image, title: Constants.EmptyRidesView.title, caption: Constants.EmptyRidesView.caption)
            }
        }
    }
}

struct PublishedRidesView_Previews: PreviewProvider {
    static var previews: some View {
        PublishedRidesView()
    }
}
