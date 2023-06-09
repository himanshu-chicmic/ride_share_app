//
//  ProfileTabViewAccount.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import SwiftUI

struct ProfileTabViewAccount: View {
    
    // MARK: - properties
    
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // array for buttons
    private var navigationLinks: [[String]]
    
    @State var logOutConfirmation: Bool = false
    
    @State var openExternalLink = false
    
    // MARK: - initializers
    
    // initialize the empty values for buttons and titles array
    init() {
        navigationLinks = [
            Constants.ProfileAccount.additionalOptions
        ]
    }
    
    // MARK: - body
    
    var body: some View {
       
        ScrollView {
            
            // nested for each loops for getting
            // data out of 2d array and display
            // in the inner loop with the value
            ForEach(navigationLinks, id: \.self) { link in
                
                ForEach(link, id: \.self) { value in
                    HStack {
                        Text(value)
                        Spacer()
                        Image(systemName: Constants.Icon.next)
                    }
                    .padding()
                    .onTapGesture {
                        if value == Constants.ProfileAccount.details[0] {
                            baseViewModel.openForgotPasswordView.toggle()
                        } else if link == Constants.ProfileAccount.additionalOptions {
                            openExternalLink.toggle()
                        }
                    }
                }
                Divider()
                    .padding(.horizontal)
            }
            .fullScreenCover(isPresented: $baseViewModel.openForgotPasswordView) {
                ForgotPasswordView()
            }
            
            Button {
                logOutConfirmation.toggle()
            } label: {
                Text(Constants.ProfileAccount.logOut)
                    .frame(
                        maxWidth    : .infinity,
                        alignment   : .leading
                    )
            }
            .padding()

        }
        .confirmationDialog(
            "",
            isPresented     : $openExternalLink,
            titleVisibility : .hidden
        ) {
            Button(Constants.ButtonText.openInBrowser, role: nil) {
                UIApplication.shared.open(URL(string: Constants.DefaultURLs.stackoverflow)!)
            }
        }
        .confirmationDialog(
            Constants.AlertDialog.logout,
            isPresented     : $logOutConfirmation,
            titleVisibility : .visible
        ) {
            Button(Constants.ProfileAccount.logOut, role: .destructive) {
                baseViewModel.sendRequestToApi(httpMethod: .DELETE, requestType: .logOut, data: [:])
            }
        }
        
        // title of app bar
        Text(Constants.LogIn.resetPassword)
        .frame(maxWidth: .infinity)
    }
}

struct ProfileTabViewAccount_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabViewAccount()
            .environmentObject(BaseViewModel())
            .environmentObject(DetailsViewModel())
    }
}
