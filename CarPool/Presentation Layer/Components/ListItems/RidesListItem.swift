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
    
    // distance of journey
    var date: String
    
    // price of ride
    var price: String
    
    var seats: Int = 1
    
    // driver details
    var driverImage: String?
    var driverName: String?
    var driverRating: String?
    
    var rideStatus: String?
    
    // MARK: - body
    
    var body: some View {
        VStack {
            VStack (spacing: 20) {
                
                ZStack (alignment: .leading) {
                                
                    VStack {
                        Image(systemName: Constants.Icon.startLocation)
                        RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                            .frame(width: 1, height: 32)
                        Image(systemName: Constants.Icon.startLocation)
                    }
                    .font(.system(size: 12))
                    .foregroundColor(.accentColor)
                    
                    HStack (alignment: .top) {
                        VStack (alignment: .leading) {
                            LocationTextView(title: startTime, location: startLoction.capitalized)
                            Divider().hidden()
                            LocationTextView(title: endTime, location: endLocation.capitalized)
                        }
                        
                        Spacer()
                        
                        if let rideStatus {
                            VStack (alignment: .trailing) {
                                Text(rideStatus.capitalized)
                                    .font(.system(size: 13))
                                    .fontWeight(.medium)
                                    .foregroundColor(.green)
                                    .padding(.vertical, 4)
                                    .padding(.horizontal, 16)
                                    .background(.green.opacity(0.1))
                                    .padding(.leading)
                                
                                Spacer()
                                
                                if driverName == nil {
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text("\(seats) \(seats == 1 ? Constants.RideDetails.seat : Constants.RideDetails.seats)")
                                            .font(.system(size: 12))
                                            .fontWeight(.light)
                                        Text(price)
                                            .font(.system(size: 14))
                                            .lineLimit(1)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.leading, 24)
                }
                if let driverImage, let driverName, let driverRating {
                        
                    Divider()
                    
                    HStack {
                        LoadImageView(driverImage: driverImage)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(driverName.capitalized)
                                .font(.system(size: 14))
                                .lineLimit(1)
                            Text(driverRating)
                                .font(.system(size: 12))
                                .fontWeight(.light)
                        }
                        Spacer()

                        VStack(alignment: .trailing, spacing: 2) {
                            Text(price)
                                .font(.system(size: 14))
                                .lineLimit(1)
                            Text("\(seats) \(seats == 1 ? Constants.RideDetails.seat : Constants.RideDetails.seats)")
                                .font(.system(size: 12))
                                .fontWeight(.light)
                        }
                    }
                }
               
            }
            .padding()
            .padding(.vertical, 10)
        }
        .background(.gray.opacity(0.05))
        .cornerRadius(4)
    }
}

struct RidesListItem_Previews: PreviewProvider {
    static var previews: some View {
        RidesListItem(
            startLoction    : "chandigarh",
            startTime       : "4:00 pm",
            endLocation     : "patiala",
            endTime         : "5:00 pm",
            date            : "12-06-2023",
            price           : "Rs. 100",
            seats: 2,
            driverImage     : Constants.Images.carpool,
            driverName      : "The Protagonist",
            driverRating    : Formatters.getRatings(ratings: 4.5)
        )
    }
}
