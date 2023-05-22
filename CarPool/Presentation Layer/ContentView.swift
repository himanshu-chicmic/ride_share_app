//
//  ContentView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: - properties
    @StateObject var signInViewModel = SignInViewModel()
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @State var navigate: Bool = false
    
    // MARK: - body
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Spacer()
                
                // onboarding image
                Image(Constants.Images.introImage)
                    .resizable()
                    .frame(height: 204)
                    .padding()
                
                // onboarding title
                Text(Constants.Onboarding.title)
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                // sign up button
                Button {
                    signInViewModel.isNewUser = true
                    navigate.toggle()
                } label: {
                    DefaultButtonLabel(text: Constants.SignUp.signUp)
                }
                
                // log in button
                Button {
                    signInViewModel.isNewUser = false
                    navigate.toggle()
                } label: {
                    DefaultButtonLabel(
                        text        : Constants.LogIn.logIn,
                        isPrimary   : false
                    )
                }

            }
            // navigate to specified
            // destination view when the
            // navigate bool is set to true
            .navigationDestination(isPresented: $navigate) {
                    LoginSignupView()
                        .navigationBarBackButtonHidden(true)
            }
            .padding()
        }
        .environmentObject(signInViewModel)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SignInViewModel())
    }
}
