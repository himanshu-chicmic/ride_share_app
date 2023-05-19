//
//  ProfileViewItem.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

/// item view for profile page
/// the item view has title and button
/// that is used in profile about view
struct ProfileViewItem: View {
    
    // MARK: - properties
    
    // title and buttons text array
    var title: String
    var array: [String]
    
    // MARK: - body
    
    var body: some View {
        VStack (alignment: .leading){
            // title
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.semibold)
            
            // buttons
            ForEach(array, id: \.self) { val in
                Button {
                    //
                } label: {
                    
                    HStack{
                        // plus circle image
                        Image(systemName: Constants.Icon.plusCircle)
                        
                        // text value of button
                        Text(val)
                            .font(.system(size: 18))
                        
                        // spacer to occupy extra space
                        // at the trailing of hstack
                        Spacer()
                    }
                }
                .padding(.vertical, 8)
            }

        }
    }
}

struct ProfileViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewItem(
            title   : "Title",
            array   : Constants.ProfileButtons.verifyProfile
        )
    }
}
