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
    
    // driver details
    var driverImage: String
    var driverName: String
    var driverRating: String
    
    // MARK: - body
    
    var body: some View {
        VStack {
            HStack {
                
                VStack {
                    Image(systemName: Constants.Icon.startLocation)
                    
                    RoundedRectangle(cornerSize: CGSize(width: 4, height: 4))
                        .frame(width: 1, height: 54)
                    
                    Image(systemName: Constants.Icon.startLocation)
                }
                .font(.system(size: 12))
                .foregroundColor(.gray.opacity(0.5))
                
                VStack (alignment: .leading) {
                    
                    LocationTextView(title: startTime, location: startLoction)
                    
                    Divider()
                    
                    LocationTextView(title: endTime, location: endLocation)
                }
                .padding(.leading, 8)
            }
            .padding()
            
            Divider()
            
            HStack {
                
                LoadImageView(driverImage: driverImage)
                
                VStack (alignment: .leading) {
                    Text(driverName)
                        .font(.system(size: 14))
                    Text(driverRating)
                        .font(.system(size: 12, weight: .light))
                }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Text(date)
                        .font(.system(size: 13, weight: .light))
                    Text(price)
                }
                
            }
            .padding(.top, 4)
            .padding([.bottom, .horizontal])
        }
        .background(.gray.opacity(0.05))
        .cornerRadius(12)
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
            driverImage     : Constants.Images.carpool,
            driverName      : "The Protagonist",
            driverRating    : "4.9/5"
        )
    }
}
