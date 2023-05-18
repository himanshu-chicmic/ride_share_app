//
//  ProfileTabViewAbout.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

struct ProfileTabViewAbout: View {
    
    // MARK: properties
    
    // array for buttons
    private var buttonsArray: [[String]]
    // array for title
    private var titles: [String]
    
    // MARK: initializers
    
    // initialize the empty values for buttons and titles array
    init() {
        buttonsArray = [
            Constants.ProfileButtons.verifyProfile,
            Constants.ProfileButtons.aboutYou,
            Constants.ProfileButtons.vehicles
        ]
        
        titles = [
            Constants.ProfileButtons.verify,
            Constants.ProfileButtons.about,
            Constants.ProfileButtons.vehicle
        ]
    }

    
    // MARK: body
    
    var body: some View {
        VStack{
            Image(Constants.Images.introImage)
                .resizable()
                .scaledToFill()
                .frame(width: 124, height: 124)
                .clipShape(Circle())
            
            Text("Himanshu Goyal")
                .font(.title2)
                .fontWeight(.semibold)
            
            Button {
                //
            } label: {
                HStack (alignment: .firstTextBaseline, spacing: 5){
                    
                    
                    Text(Constants.ProfileButtons.edit)
                    
                    Image(systemName: Constants.Icon.edit)
                        .resizable()
                        .frame(width: 12, height: 12)
                }
                .font(.system(size: 16))
            }
            
            Divider()
                .padding(.vertical)
            
            ForEach(0..<3) { i in
                ProfileViewItem(title: titles[i], array: buttonsArray[i])
                
                Divider()
                    .padding(.bottom)
            }
        }
        .padding()
    }
}

struct ProfileTabViewAbout_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabViewAbout()
    }
}
