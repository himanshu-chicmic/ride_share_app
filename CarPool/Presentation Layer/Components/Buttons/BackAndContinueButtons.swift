//
//  BackAndContinueButtons.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import SwiftUI

struct BackAndContinueButtons: View {
    
    // MARK: - properties
    
    // boolena for checking increment or decrement
    var increment: Bool = true
    
    // environment objects
    @EnvironmentObject var detailsViewModel: DetailsViewModel
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // MARK: - body
    
    var body: some View {
        
        Button(action: {
            // validate and continue
            detailsViewModel.validateProfileData(
                increment     : increment,
                emailPassword : signInViewModel.textFieldValues
            )
  
        }, label: {
            DefaultButtonLabel(
                text      : increment
                            ? Constants.Others.next
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
