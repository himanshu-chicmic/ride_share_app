//
//  EditProfileView.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import SwiftUI

struct EditDetailsView: View {
    
    // MARK: - properties
    
    // MARK: environment objcts
    // environment objects of view models
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // environment variable
    @Environment(\.dismiss) var dismiss
    
    // MARK: state variables
    // state variable array for textfield values
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    // state var for confirmation
    @State var popViewConfirmation: Bool = false
    
    // MARK: view properties for ui
    // title at the top of appbar
    var title: String
    // to check if view is opened for profile
    // view or for adding vehicles
    var isProfile: Bool = true
    
    // MARK: - body
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack {
                
                ZStack (alignment: .centerFirstTextBaseline) {
                    // title of app bar
                    Text(title)
                    .frame(maxWidth: .infinity)
                    
                    // app bar at the top
                    HStack {
                        
                        // button to pop view
                        Button(action: {
                            popViewConfirmation.toggle()
                        }, label: {
                            Text(Constants.Others.cancel)
                                .font(.system(size: 15))
                        })
                        
                        Spacer()
                        
                        // save button
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
                            Text(Constants.Others.save)
                                .font(.system(size: 15))
                        }
                        
                    }
                    .padding(.horizontal, 4)
                }
                .padding()
                .padding(.bottom)
                
                ScrollView {
                    // for each loop to put
                    // input fields to the view
                    // the for each loop works for the array textFieldValue[]
                    // which contains necessary information of the fields to add
                    ForEach($textFieldValues.indices, id: \.self) { index in
                        
                        if isProfile {
                            Text(Constants.ProfileAccount.headings[index])
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding([.horizontal, .top])
                        }
                        
                        DefaultInputField(
                            inputFieldType  : textFieldValues[index].2,
                            placeholder     : textFieldValues[index].1,
                            text            : $textFieldValues[index].0,
                            keyboard        : textFieldValues[index].3,
                            background: .white
                        )
                        .padding(.bottom, isProfile ? 0 : 18)
                        
                    }

                }
            }
            .overlay {
                CircleProgressView()
            }
            .onAppear {
                // populate text field values
                // array when the view appears
                if isProfile {
                    textFieldValues = detailsViewModel.userModel.getInputFields(data: baseViewModel.userData)
                    
                    detailsViewModel.setPickerData()
                } else {
                    textFieldValues = VehicleModel().getInputFields()
                }
            }
            .onDisappear {
                // func to reset picker data
                detailsViewModel.resetPickerData()
            }
            // ask a confirmation before exiting
            .confirmationDialog(
                Constants.AlertDialog.areYouSure,
                isPresented     : $popViewConfirmation,
                titleVisibility : .visible
            ) {
                Button(Constants.Others.close, role: .destructive) {
                    if isProfile {
                        baseViewModel.editDetailsVehiclesProfile = false
                    } else {
                        dismiss()
                    }
                }
                Button(Constants.Others.dismiss, role: .cancel) {}
            }
            .sheet(isPresented: $detailsViewModel.showPicker) {
                DefaultPickers(
                    pickerType: detailsViewModel.pickerType, date: $detailsViewModel.date
                )
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

struct EditDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        EditDetailsView(title: Constants.UserInfo.title)
            .environmentObject(DetailsViewModel())
            .environmentObject(BaseViewModel())
    }
}
