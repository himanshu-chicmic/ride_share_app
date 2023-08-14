//
//  ProfileTabViewAbout.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI
import PhotosUI


//struct GetImage: View {
//    var image: Image
//
//    var body: some View {
//        if let image = phase.image {
//            Image(Constants.Images.carpool)
//                .resizable()
//                .scaledToFill()
//        } else {
//            Image(Constants.Images.carpool)
//                .resizable()
//                .scaledToFill()
//        }
//    }
//}

struct ProfileTabViewAbout: View {
    
    // MARK: - properties
    
    // MARK: environment objects
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    // MARK: private state variables
    @State private var photosPicker: PhotosPickerItem?
    
    // MARK: - body
    
    var body: some View {
        ScrollView {
            
            VStack {
                AsyncImage(url: baseViewModel.userData?.status.imageURL, content: view)
                    .frame(width: 124, height: 124)
                    .clipShape(Circle())
                .onTapGesture {
                    detailsViewModel.editPhoto.toggle()
                }
                .photosPicker(isPresented: $detailsViewModel.openPhotosPicker, selection: $photosPicker)
                .onChange(of: photosPicker) { _ in
                    Task {
                        if let data = try? await photosPicker?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                baseViewModel.sendRequestToApi(httpMethod: .PUT, requestType: .uploadImage, data: [Constants.JsonKeys.image: uiImage])
                                return
                            }
                        }
                    }
                }
                // confirmation dialog
                // to get image from gallery
                .confirmationDialog("", isPresented : $detailsViewModel.editPhoto) {
                    Button(Constants.ImagePicker.selectFromGallery) {
                        detailsViewModel.openPhotosPicker.toggle()
                    }
                }
                .padding(.top)
                
                // user name
                Text(
                    "\(baseViewModel.userData?.status.data?.firstName ?? Constants.Defaults.defaultUserF) \(baseViewModel.userData?.status.data?.lastName ?? Constants.Defaults.defaultUserL)"
                )
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .padding(.bottom, 1)
                
                // edit profile button
                Button {
                    baseViewModel.editProfile.toggle()
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        // profile text
                        Text(Constants.ProfileButtons.edit)
                        
                        // profie icon
                        Image(systemName: Constants.Icon.edit)
                            .resizable()
                            .frame(width: 12, height: 12)
                    }
                    .font(.system(size: 16))
                }
                // edit details view
                .navigationDestination(isPresented: $baseViewModel.editProfile) {
                    EditDetailsView(title: Constants.UserInfo.title)
                }
                .navigationDestination(isPresented: $baseViewModel.addVehicle) {
                    EditDetailsView(title: Constants.Headings.vehicle, isProfile: false)
                }
                
                Divider()
                    .padding(.vertical)
                
                ForEach(detailsViewModel.titles.indices, id: \.self) { index in
                    
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
    
    @ViewBuilder
    private func view(for phase: AsyncImagePhase) -> some View {
        switch phase {
        case .empty:
            ZStack {
                Color.gray.opacity(0.1)
                ProgressView()
            }
        case .success(let image):
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
        case .failure:
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: "person.circle.fill")
            }
        @unknown default:
            ZStack {
                Color.gray.opacity(0.1)
                Image(systemName: "person.circle.fill")
            }
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
