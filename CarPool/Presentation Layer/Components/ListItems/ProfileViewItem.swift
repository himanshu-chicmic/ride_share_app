//
//  ProfileViewItem.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

struct ProfileViewItem: View {
    
    // MARK: properties
    
    // title and buttons text array
    var title: String
    var array: [String]
    
    // MARK: body
    
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
                        Image(systemName: Constants.Icon.plusCircle)
                        
                        Text(val)
                            .font(.system(size: 18))
                        
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
            title: "Title",
            array: Constants.ProfileButtons.verifyProfile)
    }
}
