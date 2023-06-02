//
//  AddProfileOptionView.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import SwiftUI

/// view for adding single details item in the data
struct AddProfileOptionView: View {
    
    // MARK: - properties
    
    // environment object of validations view model
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    @Environment(\.dismiss) var dismiss
    
    // text field variable
    @State var textField: String = ""
    // title heading for text field
    var heading: String
    // placeholder text for text field
    var placeholder: String
    // type of input field
    var inputField: InputFieldIdentifier
    // keyboard type
    var keyboardType: UIKeyboardType
    
    @State var otp: String = ""
    
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    var title: String
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
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
                    Text(title)
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                Text(heading)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // text field for user input
                DefaultInputField(
                    inputFieldType  : inputField,
                    placeholder     : placeholder,
                    text            : $textField,
                    keyboard        : keyboardType
                )
                .disabled(baseViewModel.viewOtpField)
                
                if baseViewModel.viewOtpField {
                    // text field for user input
                    DefaultInputField(
                        inputFieldType  : .passcode,
                        placeholder     : "Enter 4-digit passcode",
                        text            : $otp,
                        keyboard        : .numberPad
                    )
                }
                    
                // button for saving details
                Button {
                    
                    withAnimation {
                        // check for textfield validations
                        baseViewModel.toastMessage = baseViewModel
                            .validationsInstance
                            .validateTextFields(
                                textFields: [(
                                    textField,
                                    placeholder,
                                    inputField,
                                    keyboardType
                                )]
                            )
                    }
                    
                    // if toast message is empty
                    // there no error in validations and verification
                    if baseViewModel.toastMessage.isEmpty {
                        // set new password
                        // if new password is set
                        // then dismiss the view
                        
                        if !textField.isEmpty {
                            switch inputField {
                            case .email:
                                baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .confirmEmail, data: [inputField.rawValue : textField])
                            case .phoneNumber:
                                if baseViewModel.viewOtpField {
                                    baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .confirmOtp, data: [inputField.rawValue : textField, InputFieldIdentifier.passcode.rawValue : otp])
                                } else {
                                    baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .confirmPhone, data: [inputField.rawValue : textField])
                                }
                            case .bio:
                                baseViewModel.sendRequestToApi(httpMethod: .PUT, requestType: .updateProfile, data: [Constants.JsonKeys.user:[inputField.rawValue : textField]])
                            default:
                                break
                            }
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
                switch heading {
                case Constants.Headings.email:
                    textField = baseViewModel.userData?.status.data?.email ?? ""
                case Constants.Headings.mobile:
                    textField = baseViewModel.userData?.status.data?.phoneNumber ?? ""
                case Constants.Headings.bio:
                    textField = baseViewModel.userData?.status.data?.bio ?? ""
                default:
                    textField = ""
                }
            }
            .sheet(isPresented: $detailsViewModel.showPicker) {
                DefaultPickers(
                    pickerType: detailsViewModel.pickerType, date: $detailsViewModel.date
                )
            }
            .overlay {
                CircleProgressView()
            }
            .onChange(of: baseViewModel.openAddProfile, perform: { value in
                if !value {
                    dismiss()
                }
            })
            .navigationBarBackButtonHidden()
            
            // show toast message
            // if any validation or verificatioin
            // message exists
            if !baseViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
    }
}

struct AddProfileOptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileOptionView(
            heading     : "",
            placeholder : "",
            inputField  : .email,
            keyboardType: .default,
            title: Constants.UserInfo.title
        )
        .environmentObject(BaseViewModel())
        .environmentObject(DetailsViewModel())
    }
}
