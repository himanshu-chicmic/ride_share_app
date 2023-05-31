//
//  ProfileTabViewAbout.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI
import PhotosUI

struct ProfileTabViewAbout: View {
    
    // MARK: - properties
    
    // MARK: environment objects
    // environment object for base view model
    @EnvironmentObject var baseViewModel: BaseViewModel
    // details view model object
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    // MARK: private state variables
    // photos picker item
    @State private var photosPicker: PhotosPickerItem?
    // by default intialize to a default image
    // or the image set by user
    @State private var image = Image(Constants.Images.introImage)
    
    // MARK: - body
    
    var body: some View {
        ScrollView {
            VStack {
                
                // profile can be changed
                // by clicking on it
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
                    .onTapGesture {
                        // toggle edit profile button
                        detailsViewModel.editPhoto.toggle()
                    }
                    .photosPicker(isPresented: $detailsViewModel.openPhotosPicker, selection: $photosPicker)
                    .onChange(of: photosPicker) { _ in
                        Task {
                            // update the image of the user here
                            if let data = try? await photosPicker?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    image = Image(uiImage: uiImage)
                                    return
                                }
                            }
                        }
                    }
                    // confirmation dialog
                    // prompting user with options
                    // to get image from galler
                    // to click a picture
                    .confirmationDialog("", isPresented : $detailsViewModel.editPhoto) {
                        Button(Constants.ImagePicker.selectFromGallery) {
                            detailsViewModel.openPhotosPicker.toggle()
                        }
                    }
                
                // user name
                Text(
                    "\(baseViewModel.userData?.status.data?.firstName ?? "No") \(baseViewModel.userData?.status.data?.lastName ?? "Name")"
                )
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .padding(.bottom, 1)
                
                if let bio = baseViewModel.userData?.status.data?.bio {
                    Text(bio)
                        .font(.system(size: 14))
                        .padding(.bottom)
                    
                }
                
                // edit profile button
                Button {
                    // toggle edit profile button
                    baseViewModel.editDetailsVehiclesProfile.toggle()
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        // edit profile text
                        Text(Constants.ProfileButtons.edit)
                        
                        // edit profie icon
                        Image(systemName: Constants.Icon.edit)
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                    .font(.system(size: 16))
                }
                // open new view as a full screen
                // bottom sheet to edit profile details
                .fullScreenCover(isPresented: $baseViewModel.editDetailsVehiclesProfile) {
                    EditDetailsView(textFieldValues: detailsViewModel.userModel.getInputFields(data: baseViewModel.userData), title: Constants.UserInfo.title)
                }
                
                Divider()
                    .padding(.vertical)
                
                // additional buttons for profile editing
                
                ForEach(detailsViewModel.titles.indices) { index in
                    
                    // profile view item to show profile
                    // section with different buttons
                    ProfileViewItem(
                        title : $detailsViewModel.titles[index],
                        array : $detailsViewModel.buttonsArray[index]
                    )
                    
                    Divider()
                        .padding(.bottom)
                }
            }
            .padding()
        }
    }
}

struct ProfileTabViewAbout_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabViewAbout()
            .environmentObject(BaseViewModel())
            .environmentObject(DetailsViewModel())
    }
}
