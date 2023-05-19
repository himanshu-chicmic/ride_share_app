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
    @EnvironmentObject var validationsViewModel: ValidationsViewModel
    
    // signInModel for email, password and,
    // confirm password properties
    var signInModel = SignInModel()
    
    // state array to store the values
    // neccessary for the input fields
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // environment variable to dismiss the view
    @Environment(\.dismiss) var dismiss
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @State var navigateToDashboard: Bool = false
    
    // open forgot password view
    @State var openForgotPasswordView: Bool = false
    // open view for user detials
    @State var openUserDetailsView: Bool = false
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack{
                
                // app bar at the top
                ZStack (alignment: .leading){
                    
                    // button to pop view
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: Constants.Icon.back)
                    })
                    
                    // title of app bar
                    Text(signInViewModel.appBarTitle)
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                // text fields for user input
                ForEach($textFieldValues.indices, id: \.self) { i in
                    DefaultInputField(
                        inputFieldType  : textFieldValues[i].2,
                        placeholder     : textFieldValues[i].1,
                        text            : $textFieldValues[i].0,
                        keyboard        : textFieldValues[i].3
                    )
                }
                
                // forgot password for login field
                if !signInViewModel.isNewUser {
                    Button {
                        openForgotPasswordView.toggle()
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
                    
                    withAnimation{
                        // check for textfield validations
                        validationsViewModel.toastMessage = signInViewModel.isNewUser
                        ?
                        validationsViewModel.validationsInstance
                            .validateTextFields(textFields: textFieldValues, count: textFieldValues.count - 2)
                        :
                        validationsViewModel.validationsInstance
                                       .validateTextFields(textFields: textFieldValues)
                        
                        // check for email/password verification
                    }
                    
                    // if toast message is empty
                    // there no error in validations and verification
                    // then navigate to new view
                    if validationsViewModel.toastMessage.isEmpty {
                        if signInViewModel.isNewUser {
                            openUserDetailsView.toggle()
                        }else {
                            navigateToDashboard.toggle()
                        }
                    }
                    else {
                        // if any error is shown
                        // show if for 3 seconds and
                        // then make it disappear
                        DispatchQueue.main.asyncAfter(deadline: .now()+3){
                            validationsViewModel.toastMessage = ""
                        }
                    }
                    
                } label: {
                    DefaultButtonLabel(text: signInViewModel.signInButtonText)
                }
                .padding()
                
                // if user already/not a member
                HStack{
                    Text(signInViewModel.alreadyOrNotAMember)
                    
                    // button to toggle between
                    // login and signup
                    Button {
                        withAnimation {
                            signInViewModel.isNewUser.toggle()
                            // update text field values
                            // array when isNewUser toggles
                            textFieldValues = signInModel.getInputFields(isNewUser: signInViewModel.isNewUser)
                        }
                    } label: {
                        Text(signInViewModel.signUpOrLogIn)
                        .fontWeight(.semibold)
                    }
                }
                .font(.system(size: 14))
                
                // space to occupy extra space
                Spacer()
            }
            .onAppear{
                // populate text field values
                // array when the view appears
                textFieldValues = signInModel.getInputFields(isNewUser: signInViewModel.isNewUser)
            }
            // navigate to specified
            // destination view when the
            // navigate bool is set to true
            .navigationDestination(isPresented: $navigateToDashboard) {
                // navigate to dashboard view
                DashboardView()
                    .navigationBarBackButtonHidden(true)
            }
            .fullScreenCover(isPresented: $openUserDetailsView) {
                UserDetailsView()
            }
            .fullScreenCover(isPresented: $openForgotPasswordView) {
                ForgotPasswordView()
            }
            
            // show toast message
            // if any validation or verificatioin
            // message exists
            if !validationsViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
            .environmentObject(SignInViewModel())
            .environmentObject(ValidationsViewModel())
    }
}
