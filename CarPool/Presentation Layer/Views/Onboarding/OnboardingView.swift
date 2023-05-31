//
//  OnboardingView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct OnboardingView: View {
    
    // MARK: - properties
    @StateObject var signInViewModel = SignInViewModel()
    
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
                    signInViewModel.navigate.toggle()
                } label: {
                    DefaultButtonLabel(text: Constants.SignUp.signUp)
                }
                
                // log in button
                Button {
                    signInViewModel.isNewUser = false
                    signInViewModel.navigate.toggle()
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
            .navigationDestination(isPresented: $signInViewModel.navigate) {
                LoginSignupView()
            }
            .padding()
        }
        // set environment object for signin view model
        .environmentObject(signInViewModel)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(SignInViewModel())
    }
}
