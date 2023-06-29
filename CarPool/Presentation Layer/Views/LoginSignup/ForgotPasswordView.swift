//
//  ForgotPasswordView.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    // MARK: - properties
    
    // environment objects
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // state variables
    @State var navigate: Bool = true
    @State var popViewConfirmation: Bool = false
    
    // state arrays
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // instances
    private var signInModel = SignInModel()
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                // app bar
                ZStack(alignment: .leading) {
                    
                    // close button
                    Button(action: {
                        if navigate {
                            popViewConfirmation.toggle()
                        } else {
                            baseViewModel.openForgotPasswordView.toggle()
                        }
                    }, label: {
                        Image(systemName: navigate ? Constants.Icon.back : Constants.Icon.close)
                    })
                    .confirmationDialog(Constants.AlertDialog.exitPasswordReset,
                        isPresented     : $popViewConfirmation,
                        titleVisibility : .visible) {
                        
                        Button(Constants.Others.yes, role: .destructive) {
                            navigate.toggle()
                        }
                        Button(Constants.Others.no, role: .cancel) {}
                    }
                    
                    // app bar title
                    Text(Constants.LogIn.resetPassword)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                Text(navigate ? Constants.LogIn.enterNewPassword : Constants.LogIn.resetPasswordDescription)
                    .font(.system(size: 18, design: .rounded))
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // text fields
                ForEach($textFieldValues.indices, id: \.self) { index in
                    DefaultInputField(
                        inputFieldType : textFieldValues[index].2,
                        placeholder    : textFieldValues[index].1,
                        text           : $textFieldValues[index].0,
                        keyboard       : textFieldValues[index].3
                    )
                }

                // submit button
                Button {
                    signInViewModel.initiateForgotPassword(textFieldValues: textFieldValues, isNavigated: navigate)
                    
                } label: {
                    DefaultButtonLabel(text: Constants.LogIn.submit)
                }
                .padding()
                
                Spacer()
            }
            .onAppear {
                navigate = false
            }
            .onDisappear {
                baseViewModel.toastMessage = ""
            }
            .onChange(of: navigate) { val in
                
                // populate text field values
                textFieldValues = signInModel.getInputFields(isNewUser: val)
                if val {
                    // removing first we need password and confirm password
                    textFieldValues.removeFirst()
                } else {
                    // removing last we need email address
                    textFieldValues.removeLast()
                }
            }
            // progress bar
            .overlay {
                CircleProgressView()
            }
            
            // toast message for validation errors
            if !baseViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .environmentObject(BaseViewModel())
    }
}
