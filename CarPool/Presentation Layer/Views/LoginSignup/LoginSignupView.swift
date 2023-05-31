//
//  LoginSignupView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct LoginSignupView: View {
    
    // MARK: - properties
    
    // environment object for view models
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                // app bar at the top
                ZStack(alignment: .leading) {
                    
                    // button to pop view
                    Button(action: {
                        signInViewModel.navigate.toggle()
                    }, label: {
                        Image(systemName: Constants.Icon.back)
                    })
                    
                    // title of app bar
                    Text(signInViewModel.appBarTitle)
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                ScrollView {
                    // text fields for user input
                    ForEach($signInViewModel.textFieldValues.indices, id: \.self) { index in
                        DefaultInputField(
                            inputFieldType : signInViewModel.textFieldValues[index].2,
                            placeholder    : signInViewModel.textFieldValues[index].1,
                            text           : $signInViewModel.textFieldValues[index].0,
                            keyboard       : signInViewModel.textFieldValues[index].3
                        )
                    }
                    
                    // forgot password for login field
                    if !signInViewModel.isNewUser {
                        Button {
                            baseViewModel.openForgotPasswordView.toggle()
                        } label: {
                            Text(Constants.LogIn.forgotPassword)
                                .font(.system(size: 14))
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(.top, 6)
                        .padding(.horizontal, 20)
                    }

                    // button for navigation to a new view
                    Button {
                        // initialize signin
                        signInViewModel.initiateSignIn()
                    } label: {
                        DefaultButtonLabel(text: signInViewModel.signInButtonText)
                    }
                    .padding()
                    
                    // if user already/not a member
                    HStack {
                        Text(signInViewModel.alreadyOrNotAMember)
                        
                        // button to toggle between
                        // login and signup
                        Button {
                            withAnimation {
                                // switch view state
                                signInViewModel.isNewUser.toggle()
                                // update text fields
                                signInViewModel.resetTextFields()
                            }
                        } label: {
                            Text(signInViewModel.signUpOrLogIn)
                            .fontWeight(.semibold)
                        }
                    }
                    .font(.system(size: 14))
                }
            }
            // hides default back button in navigation
            .navigationBarBackButtonHidden()
            // overlay for progress bar
            .overlay {
                CircleProgressView()
            }
            // full screen cover view for presenting
            // views appearing from bottom
            // used for details view and forgot password view
            .fullScreenCover(isPresented: $baseViewModel.openUserDetailsView) {
                UserDetailsView()
            }
            .fullScreenCover(isPresented: $baseViewModel.openForgotPasswordView) {
                ForgotPasswordView()
            }
            // reset text field values when the view appears
            .onAppear {
                signInViewModel.resetTextFields()
            }
            // when the view disappears clear the toast Message
            // if any is shown in the view
            .onDisappear {
                baseViewModel.toastMessage = ""
            }
            
            // show toast message
            // if any validation or verificatioin
            // message exists
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
