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
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // userModel for first name,
    // last name, date of birth and,
    // gender properties
    var userModel = UserModel()
    
    // state variable array for textfield values
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // state var for confirmation
    @State var popViewConfirmation: Bool = false
    
    var title: String
    
    var isProfile: Bool = true
    
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
                    Text(title)
                    .frame(maxWidth: .infinity)
                    
                    Button {
                        if isProfile {
                            detailsViewModel.validateCompleteProfile(textFieldValues: textFieldValues)
                        } else {
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
            .overlay {
                CircleProgressView()
            }
            .onAppear {
                // populate text field values
                // array when the view appears
                if isProfile {
                    textFieldValues = userModel.getInputFields(data: baseViewModel.userData)
                    
                    detailsViewModel.setPickerData()
                } else {
                    textFieldValues = VehicleModel().getInputFields()
                }
            }
            .onDisappear {
                // func to reset picker data
                detailsViewModel.resetPickerData()
            }
            .sheet(isPresented: $detailsViewModel.showPicker) {
                DefaultPickers(
                    pickerType: detailsViewModel.pickerType, date: $detailsViewModel.date
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

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(title: Constants.UserInfo.title)
            .environmentObject(DetailsViewModel())
            .environmentObject(BaseViewModel())
    }
}
