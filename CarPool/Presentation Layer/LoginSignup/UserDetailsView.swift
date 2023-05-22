//
//  UserDetailsView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct UserDetailsView: View {
    
    // MARK: - properties
    
    // environment object for view models
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var validationsViewModel: ValidationsViewModel
    @EnvironmentObject var userDetailsViewModel: UserDetailsViewModel
    
    // userDetailsModel for first name,
    // last name, date of birth and,
    // gender properties
    var userDetailsModel = UserDetailsModel()
    
    // state array to store the values
    // neccessary for the input fields
    @State var textFieldValues: [Constants.TypeAliases.InputFieldArrayType] = []
    
    // progress value for profile completion
    // increments by 30 points
    @State private var profileCompletion = 0.0
    
    // property to get the index value
    // from profileCompletion state var
    // this index is used to get the value
    // from titles array in Constants
    private var index: Int {
        Int(profileCompletion/Constants.UserDetails.progressIncrements) - 1
    }
    
    // environment variable to dismiss the view
    @Environment(\.dismiss) var dismiss
    
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
                        // navigate back
                        // dismiss after asking a confirmation
                        popViewConfirmation.toggle()
                    }, label: {
                        Image(systemName: Constants.Icon.close)
                    })
                    // ask a confirmation before exiting
                    .confirmationDialog(
                        Constants.AlertDialog.exitCompleteProfile,
                        isPresented     : $popViewConfirmation,
                        titleVisibility : .visible
                    ) {
                        Button(Constants.Others.yes, role: .destructive) {
                            dismiss()
                        }
                        Button(Constants.Others.no, role: .cancel) {}
                    }
    
                    // title for app bar
                    Text(Constants.UserDetails.title)
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .padding(.bottom)
                
                // progress bar
                ProgressView(
                    String(format: Constants.UserDetails.progress, index+1),
                    value   : profileCompletion,
                    total   : Constants.UserDetails.progressCompletion
                )
                .padding()
                .font(.system(size: 13))
                
                // if profileCompletion value is greater
                // than 0 then show the content of this page
                if profileCompletion > 0 {
                    
                    // title
                    Text(Constants.UserDetails.titles[index])
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // for each loop to put
                    // input fields to the view
                    // the for each loop works for the 2d array textFieldValue[[]]
                    // which contains necessary information of the fields to add
                    ForEach($textFieldValues[index].indices, id: \.self) { value in
                        DefaultInputField(
                            inputFieldType  : textFieldValues[index][value].2,
                            placeholder     : textFieldValues[index][value].1,
                            text            : $textFieldValues[index][value].0,
                            keyboard        : textFieldValues[index][value].3
                        )
                    }
                    
                    // button for back and continue
                    // complete profile steps
                    HStack {
                        if index > 0 {
                            // back button
                            BackAndContinueButtons(
                                completion  : $profileCompletion,
                                increment   : false,
                                textFields  : $textFieldValues[0]
                            )
                        }
                        // continue button
                        BackAndContinueButtons(
                            completion  : $profileCompletion,
                            increment   : true,
                            textFields  : $textFieldValues[0]
                        )
                    }
                    .padding()
                    
                }
                
                // spacer to occupy extra space
                Spacer()
            }
            .onAppear {
                // increase the profile completion with +30 increment
                // to set the first step for complete profile
                profileCompletion += Constants.UserDetails.progressIncrements
                
                // populate text field values
                // array when the view appears
                textFieldValues = userDetailsModel.getInputFields2dArray()
            }
            .onDisappear {
                // func to reset picker data
                userDetailsViewModel.resetPickerData()
            }
            .overlay {
                if validationsViewModel.inProgess {
                    CircleProgressView()
                }
            }
            
            Group {
                // if show gender is set to true
                if userDetailsViewModel.showGenderPicker {
                    DefaultPickers()
                    .padding(.horizontal, 34)
                }
                
                // if show date is set to true
                if userDetailsViewModel.showDatePicker {
                    DefaultPickers()
                }
            }
            .background(.gray.opacity(0.15))
            
            // show toast message
            // if any validation or verificatioin
            // message exists
            if !validationsViewModel.toastMessage.isEmpty {
                ToastMessageView()
            }
        }
        .onChange(of: validationsViewModel.dismiss) { val in
            if val {
                dismiss()
                validationsViewModel.navigateToDashboard = true
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .environmentObject(SignInViewModel())
            .environmentObject(ValidationsViewModel())
            .environmentObject(UserDetailsViewModel())
    }
}
