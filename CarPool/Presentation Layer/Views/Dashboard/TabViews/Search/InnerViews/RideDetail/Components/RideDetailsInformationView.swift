//
//  RideDetailsInformationView.swift
//  CarPool
//
//  Created by Nitin on 6/12/23.
//

import SwiftUI

struct RideDetailsInformationView: View {

    var details: [String] = []
    
    var body: some View {
        VStack (alignment: .leading) {
            
            Text(Constants.RideDetails.details)
                .padding(.bottom, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ForEach(details, id: \.self) { value in
                if !value.isEmpty {
                    Text(value)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .padding(.vertical, 2)
                }
            }
        }
    }
}

struct RideDetailsInformationView_Previews: PreviewProvider {
    static var previews: some View {
        RideDetailsInformationView()
    }
}
