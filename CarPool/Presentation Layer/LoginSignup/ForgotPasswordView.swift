//
//  ForgotPasswordView.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    // MARK: - properties
    
    // environment object for view model
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var validationsViewModel: ValidationsViewModel
    
    // environment variable to dismiss the view
    @Environment(\.dismiss) var dismiss
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @State var navigate: Bool = true
    
    // state array to store the values
    // neccessary for the input fields
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // signInModel for email, password and,
    // confirm password properties
    var signInModel = SignInModel()
    
    // state var for confirmation
    @State var popViewConfirmation: Bool = false
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                // app bar at the top
                ZStack(alignment: .leading) {
                    
                    // button to pop view
                    Button(action: {
                        if navigate {
                            popViewConfirmation.toggle()
                        } else {
                            dismiss()
                        }
                    }, label: {
                        Image(systemName: navigate
                              ? Constants.Icon.back
                              : Constants.Icon.close)
                    })
                    // ask a confirmation before exiting
                    .confirmationDialog(
                        Constants.AlertDialog.exitPasswordReset,
                        isPresented     : $popViewConfirmation,
                        titleVisibility : .visible
                    ) {
                        Button(Constants.Others.yes, role: .destructive) {
                            navigate.toggle()
                        }
                        Button(Constants.Others.no, role: .cancel) {}
                    }
                    
                    // title of app bar
                    Text(Constants.LogIn.resetPassword)
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                Text(navigate
                     ? Constants.LogIn.enterNewPassword
                     : Constants.LogIn.resetPasswordDescription)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // text fields for user input
                ForEach($textFieldValues.indices, id: \.self) { index in
                    DefaultInputField(
                        inputFieldType  : textFieldValues[index].2,
                        placeholder     : textFieldValues[index].1,
                        text            : $textFieldValues[index].0,
                        keyboard        : textFieldValues[index].3
                    )
                }

                // button for navigation to a new view
                Button {
                    
                    withAnimation {
                        // check for textfield validations
                        validationsViewModel.toastMessage = navigate
                        ? validationsViewModel
                            .validationsInstance
                            .validateTextFields(
                                textFields: textFieldValues,
                                count: textFieldValues.count - 2
                            )
                        : validationsViewModel
                            .validationsInstance
                            .validateTextFields(
                                textFields: textFieldValues
                            )
                        
                        // check for verification
                    }
                    
                    // if toast message is empty
                    // there no error in validations and verification
                    // then navigate to new view
                    if validationsViewModel.toastMessage.isEmpty {
                        if navigate {
                            // set new password
                            // if new password is set
                            // then dismiss the view
                            dismiss()
                        } else {
                            navigate.toggle()
                        }
                    } else {
                        // if any error is shown
                        // show if for 3 seconds and
                        // then make it disappear
                        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                            validationsViewModel.toastMessage = ""
                        }
                    }
                    
                } label: {
                    DefaultButtonLabel(text: Constants.LogIn.submit)
                }
                .padding()
                
                // space to occupy extra space
                Spacer()
            }
            .onAppear {
                navigate = false
            }
            .onChange(of: navigate) { val in
                if val {
                    // populate text field values
                    // array when the view appears
                    textFieldValues = signInModel.getInputFields(isNewUser: true)
                    // removing first value email
                    // we only need password and confirm password
                    textFieldValues.removeFirst()
                } else {
                    // populate text field values
                    // array when the view appears
                    textFieldValues = signInModel.getInputFields(isNewUser: false)
                    // removing last value of password
                    // we only need email
                    textFieldValues.removeLast()
                }
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

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(SignInViewModel())
            .environmentObject(ValidationsViewModel())
    }
}
