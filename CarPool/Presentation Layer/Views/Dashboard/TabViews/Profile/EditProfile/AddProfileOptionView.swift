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
    
    // environment object for dismiss the view
    @Environment(\.dismiss) var dismiss
    
    // environment object of validations view model
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
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
    
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
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
                        if heading == Constants.Headings.vehicle {
                            popViewConfirmation.toggle()
                        } else {
                            dismiss()
                        }
                    }, label: {
                        Image(systemName: Constants.Icon.close)
                    })
                    
                    // title of app bar
                    Text(Constants.UserInfo.title)
                    .frame(maxWidth: .infinity)
                    
                }
                .padding()
                .padding(.bottom)
                
                Text(heading)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if heading == Constants.Headings.vehicle {
                    
                    ScrollView {
                        // text fields for user input
                        ForEach($textFieldValues.indices, id: \.self) { index in
                            
                            // title
                            Text(Constants.Placeholders.vehicleTitles[index])
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.horizontal, .top])
                            
                            DefaultInputField(
                                inputFieldType  : textFieldValues[index].2,
                                placeholder     : textFieldValues[index].1,
                                text            : $textFieldValues[index].0,
                                keyboard        : textFieldValues[index].3,
                                background: .white
                            )
                        }
                    }
                    
                } else {
                    // text field for user input
                    DefaultInputField(
                        inputFieldType  : inputField,
                        placeholder     : placeholder,
                        text            : $textField,
                        keyboard        : keyboardType
                    )
                }

                // button for saving details
                Button {
                    
                    withAnimation {
                        if heading == Constants.Headings.vehicle {
                            // check for textfield validations
                            baseViewModel.toastMessage = baseViewModel
                                .validationsInstance
                                .validateTextFields(
                                    textFields: textFieldValues
                                )
                            
                            if baseViewModel.toastMessage.isEmpty {
                                baseViewModel.toastMessage = baseViewModel.validationsInstance
                                    .validatePickerSelectedValue(
                                        value       : detailsViewModel.country,
                                        placeholder : Constants.Vehicle.country,
                                        error       : Constants.ValidationMessages.noCountrySelection
                                    )
                            }
                            
                            if baseViewModel.toastMessage.isEmpty {
                                baseViewModel.toastMessage = baseViewModel.validationsInstance
                                    .validatePickerSelectedValue(
                                        value       : detailsViewModel.color,
                                        placeholder : Constants.Vehicle.color,
                                        error       : Constants.ValidationMessages.noColorSelected
                                    )
                            }
                            
                            if baseViewModel.toastMessage.isEmpty {
                                baseViewModel.toastMessage = baseViewModel.validationsInstance
                                    .validatePickerSelectedValue(
                                        value       : detailsViewModel.year,
                                        placeholder : Constants.Vehicle.modelYear,
                                        error       : Constants.ValidationMessages.noYearSelected
                                    )
                            }
                            
                        } else {
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
                                baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .confirmPhone, data: [inputField.rawValue : textField])
                            case .bio:
                                baseViewModel.sendRequestToApi(httpMethod: .PUT, requestType: .updateProfile, data: [Constants.JsonKeys.user:[inputField.rawValue : textField]])
                            default:
                                break
                            }
                        } else {
                            dismiss()
                        }
                    }
                    
                } label: {
                    DefaultButtonLabel(text: Constants.LogIn.submit)
                }
                .padding()
                
                // space to occupy extra space
                Spacer()
                
            }
            // ask a confirmation before exiting
            .confirmationDialog(
                Constants.AlertDialog.areYouSure,
                isPresented     : $popViewConfirmation,
                titleVisibility : .visible
            ) {
                Button(Constants.Others.yes, role: .destructive) {
                    dismiss()
                }
                Button(Constants.Others.no, role: .cancel) {}
            }
            .onAppear {
                switch heading {
                case Constants.Headings.vehicle:
                    textFieldValues = VehicleModel().getInputFields()
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
                    pickerType: detailsViewModel.pickerType
                )
            }
            .onChange(of: baseViewModel.dismiss) { newValue in
                if newValue {
                    dismiss()
                }
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

struct AddProfileOptionView_Previews: PreviewProvider {
    static var previews: some View {
        AddProfileOptionView(
            heading     : "",
            placeholder : "",
            inputField  : .email,
            keyboardType: .default
        )
        .environmentObject(BaseViewModel())
        .environmentObject(DetailsViewModel())
    }
}
