//
//  UserDetailsView.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct UserDetailsView: View {
    
    // MARK: - properties
    
    // environment objects
    @EnvironmentObject var baseViewModel: BaseViewModel
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    
    // state variables
    @State var popViewConfirmation: Bool = false
    
    // MARK: - body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                
                // app bar
                ZStack(alignment: .leading) {
                    
                    // close button
                    Button(action: {
                        popViewConfirmation.toggle()
                    }, label: {
                        Image(systemName: Constants.Icon.close)
                    })
                    // confirmation dialog
                    .confirmationDialog(Constants.AlertDialog.exitCompleteProfile,
                        isPresented     : $popViewConfirmation,
                        titleVisibility : .visible
                    ) {
                        Button(Constants.Others.yes, role: .destructive) {
                            baseViewModel.openUserDetailsView.toggle()
                        }
                        Button(Constants.Others.no, role: .cancel) {}
                    }
    
                    // app bar title
                    Text(Constants.UserDetails.title)
                        .frame(maxWidth: .infinity)
                        .fontWeight(.medium)
                }
                .padding()
                .padding(.bottom)
                
                // progress bar
                ProgressView(String(format: Constants.UserDetails.progress, detailsViewModel.index+1),
                    value : detailsViewModel.profileCompletion,
                    total : Constants.UserDetails.progressCompletion
                )
                .padding()
                .font(.system(size: 13))
                .tint(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
                
                // if `profileCompletion > 0` then show the content of this page
                if detailsViewModel.profileCompletion > 0 {
                    
                    ScrollView {
                        // title
                        Text(Constants.UserDetails.titles[detailsViewModel.index])
                            .font(.system(size: 18, design: .rounded))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // input fields depending on the progress view's position
                        ForEach($detailsViewModel.textFieldValues[detailsViewModel.index].indices, id: \.self) { value in
                            DefaultInputField(
                                inputFieldType : detailsViewModel.textFieldValues[detailsViewModel.index][value].2,
                                placeholder    : detailsViewModel.textFieldValues[detailsViewModel.index][value].1,
                                text           : $detailsViewModel.textFieldValues[detailsViewModel.index][value].0,
                                keyboard       : detailsViewModel.textFieldValues[detailsViewModel.index][value].3
                            )
                        }
                        
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
            .onAppear {
                detailsViewModel.profileCompletion += Constants.UserDetails.progressIncrements
                detailsViewModel.resetTextFields()
            }
            .onDisappear {
                detailsViewModel.resetPickerData()
                baseViewModel.toastMessage = ""
            }
            // pickers
            .sheet(isPresented: $detailsViewModel.showPicker) {
                DefaultPickers(
                    pickerType: detailsViewModel.pickerType,
                    date: $detailsViewModel.date
                )
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

struct UserDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailsView()
            .environmentObject(BaseViewModel())
            .environmentObject(DetailsViewModel())
    }
}
