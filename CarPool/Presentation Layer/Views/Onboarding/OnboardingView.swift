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
                ZStack (alignment: .top) {
                    
                    // image view
                    Image(Constants.Images.carpool)
                        .resizable()
                        .ignoresSafeArea()
                        .scaledToFill()
                    
                    // ride share logo
                    VStack (spacing: 0) {
                        Image(Constants.Images.carpoolIcon)
                            .resizable()
                            .frame(width: 54, height: 54)
                        Text(Constants.Onboarding.rideShare)
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.bold)
                        Text(Constants.Onboarding.yourRideYourChoice)
                            .font(.system(size: 16, design: .rounded))
                            .fontWeight(.medium)
                            .padding(.top, 8)
                    }
                    .padding(34)
                }
                
                // welcome text
                Text(Constants.Onboarding.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)
                    .font(.system(size: 22, design: .rounded))
                    .fontWeight(.bold)
                
                // get started text
                Text(Constants.Onboarding.subTitle)
                    .multilineTextAlignment(.center)
                    .padding(.top, 1)
                    .font(.system(size: 18, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.gray)
                    .padding(.bottom, 34)
                
                // signup button
                Button {
                    signInViewModel.isNewUser = true
                    signInViewModel.navigate.toggle()
                } label: {
                    DefaultButtonLabel(text: Constants.SignUp.signUp)
                }
                .padding(.horizontal)
                
                // login button
                Button {
                    signInViewModel.isNewUser = false
                    signInViewModel.navigate.toggle()
                } label: {
                    DefaultButtonLabel(
                        text        : Constants.LogIn.logIn,
                        isPrimary   : false
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 24)

            }
            // next screen/view
            .navigationDestination(isPresented: $signInViewModel.navigate) {
                LoginSignupView()
            }
        }
        .environmentObject(signInViewModel)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(SignInViewModel())
    }
}
