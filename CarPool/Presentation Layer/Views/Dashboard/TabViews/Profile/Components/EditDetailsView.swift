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
    // view models
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    @EnvironmentObject var baseViewModel: BaseViewModel
    
    // MARK: state variables
    // textfield values
    @State var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    @State var popViewConfirmation: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
    // MARK: view properties for ui
    // title at the top of appbar
    var title: String
    // to check if view for profile edit
    var isProfile: Bool = true
    
    var vehiclesData: VehiclesDataClass?
    // MARK: - body
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            VStack {
                
                ZStack {
                    
                    Text(title)
                    .frame(maxWidth: .infinity)
                    
                    HStack {
                        Button(action: {
                            popViewConfirmation.toggle()
                        }, label: {
                            Image(systemName: Constants.Icon.back)
                        })
                        
                        Spacer()
                        
                        // save button
                        Button {
                            if isProfile {
                                detailsViewModel.validateCompleteProfile(textFieldValues: textFieldValues)
                            } else {
                                detailsViewModel.validateCompleteVehicleInfo(textFieldValues: textFieldValues, vehiclesData: vehiclesData)
                            }
                        }
                        label: {
                           Text(Constants.Others.save)
                       }
                    }
                    
                }
                .padding()
                
                ScrollView {
                    // for each loop to put
                    // input fields to the view
                    // the for each loop works for the array textFieldValue[]
                    // which contains necessary information of the fields to add
                    ForEach($textFieldValues.indices, id: \.self) { index in
                        
                        Text(isProfile ? Constants.ProfileAccount.headings[index] : Constants.Vehicle.headings[index])
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
                        .padding(.bottom, 8)
                        
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
                    textFieldValues = VehicleModel().getInputFields(data: vehiclesData ?? nil)
                    detailsViewModel.setPickerData(vehiclesData: vehiclesData ?? nil)
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
                        baseViewModel.editProfile.toggle()
                    } else {
                        if vehiclesData != nil {
                            dismiss()
                        } else {
                            baseViewModel.addVehicle.toggle()
                        }
                    }
                }
                Button(Constants.Others.dismiss, role: .cancel) {}
            }
            .sheet(isPresented: $detailsViewModel.showPicker) {
                DefaultPickers(
                    pickerType: detailsViewModel.pickerType, date: $detailsViewModel.date
                )
            }
            .navigationBarBackButtonHidden()
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
