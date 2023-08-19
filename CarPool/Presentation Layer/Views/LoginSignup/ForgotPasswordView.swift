//
//  ForgotPasswordView.swift
//  CarPool
//
//  Created by Himanshu on 8/18/23.
//

import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = [
        (
            "",
            Constants.Placeholders.email,
            InputFieldIdentifier.email,
            UIKeyboardType.emailAddress
        ),
        (
            "",
            Constants.Placeholders.passcode,
            InputFieldIdentifier.passcode,
            UIKeyboardType.numberPad
        ),
        (
            "",
            Constants.Placeholders.password,
            InputFieldIdentifier.password,
            UIKeyboardType.twitter
        ),
        (
            "",
            Constants.Placeholders.reEnterPassword,
            InputFieldIdentifier.confirmPassword,
            UIKeyboardType.twitter
        )
    ]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        ZStack (alignment: .bottom) {
            VStack {
                // app bar at the top
                ZStack(alignment: .leading) {
                    
                    // button to pop view
                    Button(action: {
                        if baseViewModel.viewOtpField {
                            baseViewModel.viewOtpField.toggle()
                        }
                        dismiss()
                    }, label: {
                        Image(systemName: Constants.Icon.back)
                    })
                    
                    // title of app bar
                    Text("Forgot Password")
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                switch baseViewModel.requestTypeForgotPassword {
                case .sendOtpEmail:
                    Text("Tell us your registered email address.")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    DefaultInputField(
                        inputFieldType : textFieldValues[0].2,
                        placeholder    : textFieldValues[0].1,
                        text           : $textFieldValues[0].0,
                        keyboard       : textFieldValues[0].3
                    )
                case .emailOtpVerify:
                    Text("Verify OTP")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    DefaultInputField(
                        inputFieldType : textFieldValues[1].2,
                        placeholder    : textFieldValues[1].1,
                        text           : $textFieldValues[1].0,
                        keyboard       : textFieldValues[1].3
                    )
                default:
                    Text("Update Password")
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    DefaultInputField(
                        inputFieldType : textFieldValues[2].2,
                        placeholder    : textFieldValues[2].1,
                        text           : $textFieldValues[2].0,
                        keyboard       : textFieldValues[2].3
                    )
                    DefaultInputField(
                        inputFieldType : textFieldValues[3].2,
                        placeholder    : textFieldValues[3].1,
                        text           : $textFieldValues[3].0,
                        keyboard       : textFieldValues[3].3
                    )
                }
                
                // button for saving details
                Button {
                    withAnimation {
                        switch baseViewModel.requestTypeForgotPassword {
                        case .sendOtpEmail:
                            baseViewModel.createFogotPasswordApiCall(httpMethod: .POST, requestType: .sendOtpEmail, data: [Constants.JsonKeys.email: textFieldValues[0].0.lowercased()])
                            break
                        case .emailOtpVerify:
                            baseViewModel.createFogotPasswordApiCall(httpMethod: .POST, requestType: .emailOtpVerify, data: [Constants.JsonKeys.email: textFieldValues[0].0.lowercased(), Constants.JsonKeys.otp: textFieldValues[1].0])
                            break
                        default:
                            baseViewModel.createFogotPasswordApiCall(
                                httpMethod: .POST,
                                requestType: .resetPassword,
                                data: [Constants.JsonKeys.email: textFieldValues[0].0.lowercased(), Constants.JsonKeys.password: textFieldValues[2].0, Constants.JsonKeys.passwordConfirmation: textFieldValues[3].0]
                            )
                        }
                    }
                } label: {
                    DefaultButtonLabel(text: Constants.Others.continue_)
                }
                .padding()
                
                Spacer()
            }
            // progress bar
            .overlay {
                CircleProgressView()
            }
            
            // toast message
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
