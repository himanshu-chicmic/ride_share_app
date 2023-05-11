//
//  LoginSignupView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct LoginSignupView: View {
    
    // MARK: - properties
    
    // environment object for view model
    @EnvironmentObject var signInViewModel: SignInViewModel
    
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
    @State var navigate: Bool = false
    
    // MARK: - body
    
    var body: some View {
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

            // button for navigation to a new view
            Button(action: {
                // navigate to next view
                // after checking validations
                navigate.toggle()
            }, label: {
                DefaultButtonLabel(text: signInViewModel.signInButtonText)
            })
            .padding()
            
            // if user already/not a member
            HStack{
                Text(signInViewModel.alreadyOrNotAMember)
                
                // button to toggle between
                // login and signup
                Button(action: {
                    signInViewModel.isNewUser.toggle()
                    // update text field values
                    // array when isNewUser toggles
                    withAnimation{
                        textFieldValues = signInModel.getInputFields(isNewUser: signInViewModel.isNewUser)
                    }
                }, label: {
                    Text(signInViewModel.signUpOrLogIn)
                    .fontWeight(.semibold)
                })
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
        .navigationDestination(isPresented: $navigate) {
            
            // if the user is new
            // go to complete profile view
            if signInViewModel.isNewUser {
                UserDetailsView()
                    .navigationBarBackButtonHidden(true)
            }
            else {
                // go to home view
            }
        }
    }
}

struct LoginSignupView_Previews: PreviewProvider {
    static var previews: some View {
        LoginSignupView()
            .environmentObject(SignInViewModel())
    }
}
