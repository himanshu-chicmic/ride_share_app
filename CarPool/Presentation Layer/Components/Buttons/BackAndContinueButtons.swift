//
//  BackAndContinueButtons.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import SwiftUI

/// view for back and continue buttons
/// used in progress of profile completion
/// during creating a new account
struct BackAndContinueButtons: View {
    
    // MARK: - properties
    
    // bool to check wheter to increment
    // or decrement the value of completion
    var increment: Bool = true
    
    // environment object for view models
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // MARK: - body
    
    var body: some View {
        
        Button(action: {
            // call validateProfileData to continue
            // entering data by checking it and
            // at last step call api for create user
            detailsViewModel.validateProfileData(
                increment     : increment,
                emailPassword : signInViewModel.textFieldValues
            )
  
        }, label: {
            DefaultButtonLabel(
                text      : increment
                            ? Constants.Others.continue_
                            : Constants.Others.back,
                isPrimary : increment
            )
        })
    }
}

struct BackAndContinueButtons_Previews: PreviewProvider {
    static var previews: some View {
        BackAndContinueButtons()
    }
}
