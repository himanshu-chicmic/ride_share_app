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
    @EnvironmentObject var validationsViewModel: ValidationsViewModel
    @EnvironmentObject var userDetailsViewModel: UserDetailsViewModel
    
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
                    String(format: Constants.UserDetails.progress, userDetailsViewModel.index+1),
                    value   : userDetailsViewModel.profileCompletion,
                    total   : Constants.UserDetails.progressCompletion
                )
                .padding()
                .font(.system(size: 13))
                
                // if profileCompletion value is greater
                // than 0 then show the content of this page
                if userDetailsViewModel.profileCompletion > 0 {
                    
                    // title
                    Text(Constants.UserDetails.titles[userDetailsViewModel.index])
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    
                    // for each loop to put
                    // input fields to the view
                    // the for each loop works for the 2d array textFieldValue[[]]
                    // which contains necessary information of the fields to add
                    ForEach(
                        $userDetailsViewModel
                        .textFieldValues[userDetailsViewModel.index]
                        .indices, id: \.self
                    ) { value in
                        DefaultInputField(
                            inputFieldType  : userDetailsViewModel.textFieldValues[userDetailsViewModel.index][value].2,
                            placeholder     : userDetailsViewModel.textFieldValues[userDetailsViewModel.index][value].1,
                            text            : $userDetailsViewModel.textFieldValues[userDetailsViewModel.index][value].0,
                            keyboard        : userDetailsViewModel.textFieldValues[userDetailsViewModel.index][value].3
                        )
                    }
                    
                    // button for back and continue
                    // complete profile steps
                    HStack {
                        if userDetailsViewModel.index > 0 {
                            // back button
                            BackAndContinueButtons(
                                increment   : false,
                                textFields  : $userDetailsViewModel.textFieldValues[0]
                            )
                        }
                        // continue button
                        BackAndContinueButtons(
                            increment   : true,
                            textFields  : $userDetailsViewModel.textFieldValues[0]
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
                userDetailsViewModel.profileCompletion += Constants.UserDetails.progressIncrements
                
                // reset text fields array
                userDetailsViewModel.resetTextFields()
            }
            .onDisappear {
                // func to reset picker data
                userDetailsViewModel.resetPickerData()
            }
            // overlay for progress bar view
            .overlay {
                CircleProgressView()
            }
            // bottom sheet for pickers
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
        // on change of dismiss variable in validationsViewModel
        // dismiss this view and set navigateToDashboard to true
        .onChange(of: validationsViewModel.dismiss) { val in
            if val {
                // dismiss current view
                dismiss()
                // set navigateToDashboard to true
                validationsViewModel.navigateToDashboard = true
            }
        }
    }
}

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .environmentObject(ValidationsViewModel())
            .environmentObject(UserDetailsViewModel())
    }
}
