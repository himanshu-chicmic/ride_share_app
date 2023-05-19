//
//  RidesListItemCity.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

/// component to be displayed
/// on list item view in rides view
struct RidesListItemCity: View {
    
    // MARK: - properties
    
    // list item properties
    var icon: String
    var color: Color
    var location: String
    var time: String
    
    // MARK: - body
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            
            // icon
            Image(systemName: icon)
                .foregroundColor(color)
            
            VStack (alignment: .leading){
                    
                // location
                Text(location)
                    .font(.system(size: 18))
                
                // time
                Text(time)
                    .font(.system(size: 13))
                    .fontWeight(.light)
                
            }
            .padding(.leading, 8)
        }
    }
}

struct RidesListItemCity_Previews: PreviewProvider {
    static var previews: some View {
        RidesListItemCity(
            icon        : Constants.Icon.startLocation,
            color       : .green,
            location    : "Chandigarh",
            time        : "5:00 pm"
        )
    }
}
