//
//  RideDetailsButtonsView.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import SwiftUI

struct RideDetailsButtonsView: View {
    
    var data: Datum
    
    var body: some View {
        VStack {
            
            Rectangle()
                .frame(height: 4)
                .foregroundColor(.gray.opacity(0.05))
                .background(.gray.opacity(0.05))
                .padding(.top)
            
            Button {
                // contact driver
            } label: {
                Text(Constants.RideDetails.contact)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()

            Button {
                // contact driver
            } label: {
                Text(Constants.RideDetails.shareRide)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
}
