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
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // title and buttons text array
    @Binding var title: String
    @Binding var array: [EditProfileIdentifier]
    
    // state var to check the clicked item
    @State var clickedItem: EditProfileIdentifier = .email
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            
            if title == Constants.Headings.vehicle {
                // TODO: show a list of vehicles added
            }
            
            // title
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.semibold)
            
            // buttons
            
            ForEach(array) { val in
                Button {
                    print(val)
                    clickedItem = val
                    baseViewModel.editProfileOption.toggle()
                } label: {
                    
                    HStack {
                        // plus circle image
                        Image(systemName: Constants.Icon.plusCircle)
                        
                        // text value of button
                        Text(val.rawValue)
                            .font(.system(size: 18))
                        
                        // spacer to occupy extra space
                        // at the trailing of hstack
                        Spacer()
                    }
                }
                .padding(.vertical, 8)
            }
            .fullScreenCover(isPresented: $baseViewModel.editProfileOption) {
                clickedItem.view
            }
        }
    }
}

struct ProfileViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ProfileViewItem(
            title : .constant("Title"),
            array : .constant([.email, .mobile])
        )
        .environmentObject(BaseViewModel())
    }
}
