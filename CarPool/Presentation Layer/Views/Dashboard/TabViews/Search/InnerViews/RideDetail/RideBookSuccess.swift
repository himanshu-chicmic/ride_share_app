//
//  RideBookSuccess.swift
//  CarPool
//
//  Created by Nitin on 6/14/23.
//

import SwiftUI

struct RideBookSuccess: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    var body: some View {
        VStack {
            // image view
            Image(Constants.EmptyRidesView.image)
                .resizable()
                .frame(width: 240, height: 194)
                .padding()
            
            // title text
            Text(searchViewModel.ridePublishOrBook.title)
                .font(
                    .system(
                        size   : 22,
                        weight : .semibold,
                        design : .rounded
                    )
                )
                .padding(.top, 14)
            
            // caption text
            Text(searchViewModel.ridePublishOrBook.caption)
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
                    DefaultButtonLabel(text: Constants.Others.viewRideDetails)
                }
            }
            .padding(.vertical)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 44)
        .environmentObject(SearchViewModel())
    }
}

struct RideBookSuccess_Previews: PreviewProvider {
    static var previews: some View {
        RideBookSuccess()
    }
}
