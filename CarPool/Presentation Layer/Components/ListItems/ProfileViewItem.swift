//
//  ProfileViewItem.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

struct ShowAddedVehicles: View {
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var body: some View {
        if let data = baseViewModel.vehiclesData?.status.data {
            ForEach(data, id: \.self) { vehicle in
                AddedVehicleItem(
                    data: vehicle
                )
            }
        }
    }
}

/// item view for profile page
/// the item view has title and button
/// that is used in profile about view
struct ProfileViewItem: View {
    
    // MARK: - properties
    // environment object for base view model
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // boolean value to open edit view
    @State var openEditView = false
    
    // title and buttons text array
    @Binding var title: String
    @Binding var array: [EditProfileIdentifier]
    
    // state var to check the clicked item
    @State var clickedItem: EditProfileIdentifier = .email
    
    // MARK: - body
    
    var body: some View {
        VStack(alignment: .leading) {
            
            // title
            Text(title)
                .font(.system(size: 20))
                .fontWeight(.semibold)
            
            // buttons
            
            ForEach(array) { val in
                
                if val == .email,
                    let activation = baseViewModel.userData?.status.data?.activated,
                    activation,
                    let email = baseViewModel.userData?.status.data?.email {
                    
                    VerifiedComponent(icon: Constants.Icon.checkCircle, text: email)
                } else if val == .mobile,
                          let activation = baseViewModel.userData?.status.data?.phoneVerified,
                            activation,
                            let phone = baseViewModel.userData?.status.data?.phoneNumber {
                    
                    VerifiedComponent(icon: Constants.Icon.checkCircle, text: phone)
                } else {
                    
                    if val == .vehicles {
                        
                        ShowAddedVehicles()
                        
                    }
                    
                    Button {
                        if val == .vehicles {
                            baseViewModel.addVehicle.toggle()
                            baseViewModel.editVehicleData = nil
                        } else {
                            baseViewModel.openAddProfile.toggle()
                            openEditView.toggle()
                            clickedItem = val
                        }
                    } label: {
                        HStack (alignment: .firstTextBaseline) {
                             if val == .bio, let bio = baseViewModel.userData?.status.data?.bio {
                                
                                 VerifiedComponent(icon: Constants.Icon.checkCircle, text: bio)
                                
                            } else {
                                // plus circle image
                                Image(systemName: Constants.Icon.plusCircle)
                                // text value of button
                                Text(val.rawValue)
                                    .font(.system(size: 18))
                                
                            }
                            
                            // spacer to occupy extra space
                            // at the trailing of hstack
                            Spacer()
                        }
                    }
                    .padding(.vertical, 8)
                }
                
            }
            .navigationDestination(isPresented: $openEditView) {
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
