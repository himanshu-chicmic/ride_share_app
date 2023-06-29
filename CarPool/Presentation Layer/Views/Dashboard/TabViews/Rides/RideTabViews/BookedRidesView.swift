//
//  BookedRidesView.swift
//  CarPool
//
//  Created by Himanshu on 6/29/23.
//

import SwiftUI

struct BookedRidesView: View {
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            if !searchViewModel.bookedRidesData.isEmpty {
                ScrollView {
                    ForEach($searchViewModel.bookedRidesData, id: \.bookingID) { $data in
                        RidesListItem(
                            startLoction    : data.ride.source,
                            startTime       : Formatters.getFormattedDate(date: data.ride.time),
                            endLocation     : data.ride.destination,
                            endTime         : Formatters.getFormattedDate(date: data.ride.estimateTime),
                            date            : "\(data.ride.date ?? Constants.Placeholders.defaultTime)",
                            price           : Formatters.getPrice(price: Int(data.ride.setPrice)),
                            seats : data.seat,
                            driverImage     : "",
                            driverName      : "\(Constants.Defaults.defaultUserF) \(Constants.Defaults.defaultUserL)",
                            driverRating    : Formatters.getRatings(ratings: 0),
                            rideStatus: data.ride.status
                        )
                        .foregroundColor(.black)
                    }
                    .padding()
                }
            } else {
                PlaceholderView(image: Constants.EmptyRidesView.image, title: Constants.EmptyRidesView.title, caption: Constants.EmptyRidesView.caption)
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
