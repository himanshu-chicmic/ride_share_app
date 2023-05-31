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
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    // state var for close view confirmation
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
                            baseViewModel.openUserDetailsView.toggle()
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
                    String(format: Constants.UserDetails.progress, detailsViewModel.index+1),
                    value   : detailsViewModel.profileCompletion,
                    total   : Constants.UserDetails.progressCompletion
                )
                .padding()
                .font(.system(size: 13))
                
                // if profileCompletion value is greater
                // than 0 then show the content of this page
                if detailsViewModel.profileCompletion > 0 {
                    
                    ScrollView {
                        // title
                        Text(Constants.UserDetails.titles[detailsViewModel.index])
                            .font(.system(size: 22))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // for each loop to put
                        // input fields to the view
                        // the for each loop works for the 2d array textFieldValue[[]]
                        // which contains necessary information of the fields to add
                        ForEach(
                            $detailsViewModel
                            .textFieldValues[detailsViewModel.index]
                            .indices, id: \.self
                        ) { value in
                            DefaultInputField(
                                inputFieldType : detailsViewModel.textFieldValues[detailsViewModel.index][value].2,
                                placeholder    : detailsViewModel.textFieldValues[detailsViewModel.index][value].1,
                                text           : $detailsViewModel.textFieldValues[detailsViewModel.index][value].0,
                                keyboard       : detailsViewModel.textFieldValues[detailsViewModel.index][value].3
                            )
                        }
                        
                        // button for back and continue
                        // complete profile steps
                        HStack {
                            if detailsViewModel.index > 0 {
                                // back button
                                BackAndContinueButtons(
                                    increment : false
                                )
                            }
                            // continue button
                            BackAndContinueButtons(
                                increment : true
                            )
                        }
                        .padding()
                    }
                    
                }
                
            }
            // overlay for progress bar view
            .overlay {
                CircleProgressView()
            }
            .onAppear {
                // increase the profile completion with +30 increment
                // to set the first step for complete profile
                detailsViewModel.profileCompletion += Constants.UserDetails.progressIncrements
                
                // reset text fields array
                detailsViewModel.resetTextFields()
            }
            .onDisappear {
                // func to reset picker data
                detailsViewModel.resetPickerData()
                // empty toast message
                baseViewModel.toastMessage = ""
            }
            // bottom sheet for pickers
            .sheet(isPresented: $detailsViewModel.showPicker) {
                DefaultPickers(
                    pickerType: detailsViewModel.pickerType,
                    date: $detailsViewModel.date
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

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .environmentObject(BaseViewModel())
            .environmentObject(DetailsViewModel())
    }
}
