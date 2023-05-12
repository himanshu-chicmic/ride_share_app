//
//  BackAndContinueButtons.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import SwiftUI

struct BackAndContinueButtons: View {
    
    // MARK: - properties
    
    // binding var for progress completion
    @Binding var completion: Double
    
    // bool to check wheter to increment
    // or decrement the value of completion
    var increment: Bool = true

    // environment object for signInViewModel
    @EnvironmentObject var signInViewModel: SignInViewModel
    
    // text field values
    @Binding var textFields: Constants.TypeAliases.InputFieldArrayType
    
    // MARK: - body
    var body: some View {
        
        Button(action: {
            
            withAnimation {
                
                // check validations while incrementing
                // the complete profile steps
                
                // check for name
                if completion == 30 && increment {
                    // check for textfield validations
                    signInViewModel.toastMessage = signInViewModel.validationsInstance.validateTextFields(textFields: textFields)
                }
                
                // check for gender
                else if completion == 90 && increment {
                    // check for name prefix validations
                    signInViewModel.toastMessage = signInViewModel.validationsInstance.validateNamePrefix(value: signInViewModel.gender)
                }
                
                // increment button is pressed
                if increment {
                    // check if toast message empty
                    // and compeltion value's between 30 and 90
                    if signInViewModel.toastMessage.isEmpty
                       && completion >= 30 && completion < 90 {
                        // then increment
                        completion += 30
                    }
                    else {
                        // if any error is shown
                        // show if for 3 seconds and
                        // then make it disappear
                        DispatchQueue.main.asyncAfter(deadline: .now()+3){
                            signInViewModel.toastMessage = ""
                        }
                    }
                    
                }else {
                    // when decrement button (back) is pressed
                    completion -= 30
                }
                
            }

            
        }, label: {
            DefaultButtonLabel(
                text        : increment
                              ? Constants.Others.continue_
                              : Constants.Others.back,
                isPrimary   : increment
            )
        })
    }
}

struct BackAndContinueButtons_Previews: PreviewProvider {
    static var previews: some View {
        BackAndContinueButtons(completion: .constant(0.0), textFields: .constant([]))
    }
}
