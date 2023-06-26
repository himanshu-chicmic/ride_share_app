//
//  RideBookSuccess.swift
//  CarPool
//
//  Created by Nitin on 6/14/23.
//

import SwiftUI

struct RideBookSuccess: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // image view
            Image(Constants.EmptyRidesView.image)
                .resizable()
                .frame(width: 240, height: 194)
                .padding()
            
            // title text
            Text("You'r ride is successfully booked. ✅")
                .font(
                    .system(
                        size   : 22,
                        weight : .semibold,
                        design : .rounded
                    )
                )
                .padding(.top, 14)
            
            // caption text
            Text("Relax, we've sent information about your ride to the ride publisher.")
                .font(.system(size: 14, design: .rounded))
                .padding(.top, 2)
                .foregroundColor(.gray)
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    DefaultButtonLabel(text: Constants.Others.close, isPrimary: false)
                }
                
                Button {
                    dismiss()
                } label: {
                    DefaultButtonLabel(text: "View Ride Details")
                }
            }
            .padding(.vertical)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 44)
    }
}

struct RideBookSuccess_Previews: PreviewProvider {
    static var previews: some View {
        RideBookSuccess()
    }
}
