//
//  PrimaryButtonLabel.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

/// default button for the application
struct DefaultButtonLabel: View {
    
    // MARK: - properties
    
    // text for button
    var text: String
    
    // bool to check is button is primary
    // primary button label has a solid background
    // if not primary
    // the button label will have transparent background
    // and text color will be set to blue
    var isPrimary: Bool = true
    
    // MARK: - body
    
    var body: some View {
        
        // text for button label
        Text(text)
            .frame(maxWidth: .infinity)
            .padding()
            .font(.system(size: 14))
            .fontWeight(
                isPrimary ? .semibold : .regular
            )
            .background(
                isPrimary ? .blue : .blue.opacity(0)
            )
            .foregroundColor(
                isPrimary ? .white : .blue
            )
            .cornerRadius(4)
            .overlay {
                // if isPrimary is false
                // show a rounded rectangle overlay
                // for border of button
                if !isPrimary {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(.blue, lineWidth: 0.75)
                }
            }
    }
}

struct PrimaryButtonLabel_Previews: PreviewProvider {
    static var previews: some View {
        DefaultButtonLabel(
            text: Constants.SignUp.createAccount
        )
    }
}
