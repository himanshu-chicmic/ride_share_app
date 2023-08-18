//
//  PersonProfileView.swift
//  CarPool
//
//  Created by Nitin on 8/18/23.
//

import SwiftUI

struct PersonProfileView: View {
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    var data: Passenger?
    
    @Environment(\.dismiss) var dismiss
    
    // bool to check image loading
    @State var isLoading: Bool = true
    
    var body: some View {
        VStack {
            
            // app bar at the top
            ZStack(alignment: .leading) {
                
                // button to pop view
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Constants.Icon.back)
                })

                // title for app bar
                Text(Constants.Headings.profile)
                    .frame(maxWidth: .infinity)
            }
            .padding()
            
            Divider()
            
            if let data {
                AsyncImage(url: URL(string: data.image ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .onAppear {
                            isLoading = false
                        }
                } placeholder: {
                    if isLoading {
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView()
                        }
                    } else {
                        Image(Constants.Images.carpool)
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 84, height: 84)
                .clipShape(Circle()).onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now()+7) {
                        isLoading = false
                    }
                }
                .padding(.top)
                
                VStack (spacing: 4) {
                    Text("\(data.firstName ?? "") \(data.lastName ?? "")")
                        .font(.system(size: 18, design: .rounded))
                    if let bio = data.bio{
                        Text(bio)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.top, 8)
                
                if let phone = data.phoneNumber {
                    HStack (spacing: 2) {
                        if let verified = data.phoneVerified {
                            if verified {
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "xmark.seal.fill")
                                    .foregroundColor(.yellow)
                            }
                        }
                        Text("+91 \(phone)")
                    }.padding(.top, 4)
                }
            }
            Spacer()
        }
    }
}

struct PersonProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PersonProfileView(data: Passenger(firstName: "Bruce", lastName: "Wayne", dob: "24-06-2001", phoneNumber: "8699045644", phoneVerified: false, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRV72eA4Pfos1uk0fI2HDNogT6i0mXxtSWW2g&usqp=CAU", averageRating: nil, bio: "hello hello hello hello!!!", travelPreferences: nil, id: 91, publishID: 456, userID: 23, createdAt: nil, updatedAt: nil, price: nil, seats: nil, status: nil))
            .environmentObject(BaseViewModel())
    }
}
