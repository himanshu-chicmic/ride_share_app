//
//  RidesListItem.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import SwiftUI

/// list item view for rides data
/// used when rides data is shown
/// on search page and history of rides
struct RidesListItem: View {
    
    // MARK: - properties
    
    // departure info
    var startLoction: String
    var startTime: String
    
    // destination info
    var endLocation: String
    var endTime: String
    
    // price of ride
    var price: String
    
    // date of departure
    var dateOfDeparture: String
    
    // number of seats
    var numberOfSeats: String
    
    // driver details
    var driverImage: String
    var driverName: String
    var driverRating: String
    
    // MARK: - body
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(
                alignment : .leading,
                spacing   : 40
            ) {
                // helper layout for city name
                LocationTextViewComponent(
                    icon     : Constants.Icon.startLocation,
                    color    : .green,
                    location : startLoction,
                    time     : startTime
                )
                // helper layout for city name
                LocationTextViewComponent(
                    icon     : Constants.Icon.endLocation,
                    color    : .red,
                    location : endLocation,
                    time     : endTime
                )
                
            }
            .padding(
                [.top, .horizontal]
            )
            
            VStack {
                // price of ride
                Text(price)
                    .font(.system(size: 16))
                
                Divider()
                
                // ride info
                // date of departure and number of seats
                Text(
                    String(
                        format: Constants.RidesData.info,
                        dateOfDeparture, numberOfSeats
                    )
                )
                .font(.system(size: 10))
                .fontWeight(.light)
                
                // driver info
                VStack(spacing: 2) {
                    
                    // driver profile image
                    Image(driverImage)
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width  : 38,
                            height : 38
                        )
                        .clipShape(Circle())
                    
                    // name of the driver
                    Text(driverName)
                        .font(.system(size: 12))
                    
                    // ratings received by driver
                    HStack(
                        alignment : .firstTextBaseline,
                        spacing   : 2
                    ) {
                        Text(driverRating)
                        
                        Image(systemName: Constants.Icon.star)
                            .resizable()
                            .frame(
                                width  : 10,
                                height : 10
                            )
                            .foregroundColor(.yellow)
                    }
                    .font(.system(size: 12))
                    .fontWeight(.light)
                }
            }
            .padding()
            .background(.gray.opacity(0.05))
            
        }
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 12)
    }
}

struct RidesListItem_Previews: PreviewProvider {
    static var previews: some View {
        RidesListItem(
            startLoction    : "chandigarh",
            startTime       : "4:00 pm",
            endLocation     : "patiala",
            endTime         : "5:00 pm",
            price           : "Rs. 100",
            dateOfDeparture : "May, 23 2024",
            numberOfSeats   : "2",
            driverImage     : Constants.Images.introImage,
            driverName      : "The Protagonist",
            driverRating    : "4.9/5"
        )
    }
}
