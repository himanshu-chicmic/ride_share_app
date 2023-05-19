//
//  ProfileTabViewAccount.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

struct ProfileTabViewAccount: View {
    
    // MARK: - properties
    
    // array for buttons
    private var navigationLinks: [[String]]
    
    // MARK: - initializers
    
    // initialize the empty values for buttons and titles array
    init() {
        navigationLinks = [
            Constants.ProfileAccount.ratings,
            Constants.ProfileAccount.details,
            Constants.ProfileAccount.additionalOptions
        ]
    }
    
    // MARK: - body
    
    var body: some View {
       
        ScrollView{
            
            // nested for each loops for getting
            // data out of 2d array and display
            // in the inner loop with the value
            ForEach(navigationLinks, id: \.self) { link in
                
                ForEach(link, id: \.self) { value in
                    // content view
                    HStack{
                        // value of the text
                        Text(value)
                        Spacer()
                        // icon view
                        Image(systemName: Constants.Icon.next)
                    }
                    .padding()
                }
                
                // divider for sections
                Divider()
                    .padding(.horizontal)
            }
            
            Button {
                // TODO: add logout function
            } label: {
                Text(Constants.ProfileAccount.logOut)
                    .frame(
                        maxWidth    : .infinity,
                        alignment   : .leading
                    )
            }
            .padding()

        }
            

    }
}

struct ProfileTabViewAccount_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabViewAccount()
    }
}
