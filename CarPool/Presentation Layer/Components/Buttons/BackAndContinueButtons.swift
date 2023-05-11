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
    
    // MARK: - body
    var body: some View {
        
        Button(action: {
            
            // when increment is true
            if increment && completion == 90 {
                // navigate to back view
            }
            
            // when increment is false
            else if !increment && completion == 30 {
                // navigate to next view
            }
            
            else {
                withAnimation {
                    if increment {
                        completion += 30
                    }else {
                        completion -= 30
                    }
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
        BackAndContinueButtons(completion: .constant(0.0))
    }
}
