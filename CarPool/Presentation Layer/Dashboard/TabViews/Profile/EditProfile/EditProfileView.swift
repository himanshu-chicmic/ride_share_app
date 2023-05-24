//
//  EditProfileView.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import SwiftUI

struct EditProfileView: View {
    
    // MARK: - properties
    
    // environment variable to dismiss the view
    @Environment(\.dismiss) var dismiss
    
    // environment objects of view models
    @EnvironmentObject var userDetailsViewModel: UserDetailsViewModel
    @EnvironmentObject var validationsViewModel: ValidationsViewModel
    
    // userDetailsModel for first name,
    // last name, date of birth and,
    // gender properties
    var userDetailsModel = UserDetailsModel()
    
    // state variable array for textfield values
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // state var for confirmation
    @State var popViewConfirmation: Bool = false
    
    // MARK: - body
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack {
                
                // app bar at the top
                HStack {
                    
                    // button to pop view
                    Button(action: {
                        popViewConfirmation.toggle()
                    }, label: {
                        Image(systemName: Constants.Icon.close)
                    })
                    
                    // title of app bar
                    Text(Constants.UserInfo.title)
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        withAnimation {
                            // check for textfield validations
                            validationsViewModel.toastMessage = validationsViewModel.validationsInstance
                                           .validateTextFields(textFields: textFieldValues)
                            
                            // TODO: optimize these lines of code
                            if validationsViewModel.toastMessage.isEmpty {
                                validationsViewModel.toastMessage = validationsViewModel.validationsInstance
                                    .validatePickerSelectedValue(
                                        value       : userDetailsViewModel.gender,
                                        placeholder : Constants.Placeholders.selectGender,
                                        error       : Constants.ValidationMessages.invalidNamePrefix
                                    )
                            }
                        }
                        
                        // if toast message is empty
                        // there no error in validations and verification
                        // then navigate to new view
                        if validationsViewModel.toastMessage.isEmpty {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: Constants.Icon.check)
                    }
                    
                }
                .padding()
                .padding(.bottom)
                
                ScrollView {
                    // for each loop to put
                    // input fields to the view
                    // the for each loop works for the array textFieldValue[]
                    // which contains necessary information of the fields to add
                    ForEach($textFieldValues.indices, id: \.self) { index in
                        
                        Text(Constants.ProfileAccount.headings[index])
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
                // populate text field values
                // array when the view appears
                textFieldValues = userDetailsModel.getInputFields()
            }
            .onDisappear {
                // func to reset picker data
                userDetailsViewModel.resetPickerData()
            }
            .sheet(isPresented: $userDetailsViewModel.showPicker) {
                DefaultPickers(
                    pickerType: userDetailsViewModel.pickerType
                )
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

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .environmentObject(UserDetailsViewModel())
            .environmentObject(ValidationsViewModel())
    }
}
