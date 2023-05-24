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
    
    @EnvironmentObject var userDetailsViewModel: UserDetailsViewModel
    
    // array for buttons
    @State var buttonsArray: [[EditProfileIdentifier]] = [
        [.email, .mobile],
        [.bio],
        [.vehicles]
    ]
    // array for title
    @State var titles: [String] = [
        Constants.ProfileButtons.verify,
        Constants.ProfileButtons.about,
        Constants.ProfileButtons.vehicle
    ]
    
    // photos picker item
    @State private var photosPicker: PhotosPickerItem?
    // by default intialize to a default image
    // or the image set by user
    @State private var image = Image(Constants.Images.introImage)
    
    // booleans for opening diffrent view
    // and confirmation
    
    // open edit profile
    @State var editProfile = false
    // open image picker confirmation
    @State var editPhoto = false
    // open image picker
    @State var openImagePicker = false
    
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
                        editPhoto.toggle()
                    }
                    .photosPicker(isPresented: $openImagePicker, selection: $photosPicker)
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
                    .confirmationDialog("",
                        isPresented     : $editPhoto
                    ) {
                        Button(Constants.ImagePicker.selectFromGallery) {
                            openImagePicker.toggle()
                        }
                    }
                
                // user name
                Text(
                    userDetailsViewModel.getResponse?.getName() ?? ""
                )
                    .font(.title2)
                    .fontWeight(.semibold)
                
                // edit profile button
                Button {
                    // toggle edit profile button
                    editProfile.toggle()
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
                .fullScreenCover(isPresented: $editProfile) {
                    EditProfileView()
                }
                
                Divider()
                    .padding(.vertical)
                
                // additional buttons for profile editing
                
                ForEach(0..<3) { index in
                    
                    // profile view item to show profile
                    // section with different buttons
                    ProfileViewItem(
                        title   : $titles[index],
                        array   : $buttonsArray[index]
                    )
                    
                    Divider()
                        .padding(.bottom)
                }
            }
            .padding()
            .onAppear {
                userDetailsViewModel.callApi(httpMethod: .GET, requestType: .getDetails)
            }
        }
    }
}

struct ProfileTabViewAbout_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabViewAbout()
    }
}
