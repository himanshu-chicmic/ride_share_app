//
//  LoginSignupView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct LoginSignupView: View {
    
    // MARK: - properties
    
    // environment objects
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                // app bar
                ZStack(alignment: .leading) {
                    
                    // back button
                    Button(action: {
                        signInViewModel.navigate.toggle()
                    }, label: {
                        Image(systemName: Constants.Icon.back)
                    })
                    
                    // app bar title
                    Text(signInViewModel.appBarTitle)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                ScrollView {
                    // text fields
                    ForEach($signInViewModel.textFieldValues.indices, id: \.self) { index in
                        DefaultInputField(
                            inputFieldType : signInViewModel.textFieldValues[index].2,
                            placeholder    : signInViewModel.textFieldValues[index].1,
                            text           : $signInViewModel.textFieldValues[index].0,
                            keyboard       : signInViewModel.textFieldValues[index].3
                        )
                    }
                    
                    if !signInViewModel.isNewUser {
                        Button {
                            baseViewModel.requestTypeForgotPassword = .sendOtpEmail
                            baseViewModel.openForgotPassword.toggle()
                        } label: {
                            Text("Forgot Password?")
                        }
                        .font(.system(size: 14))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 20)
                        .padding(.top, 4)
                    }

                    // continue button
                    Button {
                        signInViewModel.initiateSignIn()
                    } label: {
                        DefaultButtonLabel(text: Constants.Others.continue_)
                    }
                    .padding()
                    
                    // if user (already or not) a member
                    HStack {
                        Text(signInViewModel.alreadyOrNotAMember)
                        
                        // button to toggle login and signup view
                        Button {
                            withAnimation {
                                signInViewModel.isNewUser.toggle()
                                signInViewModel.resetTextFields()
                            }
                        } label: {
                            Text(signInViewModel.signUpOrLogIn)
                            .fontWeight(.medium)
                        }
                    }
                    .font(.system(size: 14))
                }
            }
            .navigationBarBackButtonHidden()
            // user details view
            // opened when sign up is attempted
            .fullScreenCover(isPresented: $baseViewModel.openUserDetailsView) {
                UserDetailsView()
            }
            .fullScreenCover(isPresented: $baseViewModel.openForgotPassword) {
                ForgotPasswordView()
            }
            .onAppear {
                signInViewModel.resetTextFields()
            }
            // progress bar
            .overlay {
                CircleProgressView()
            }
            // toast message for validation or errors
            if !baseViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
            .environmentObject(SignInViewModel())
            .environmentObject(BaseViewModel())
    }
}
