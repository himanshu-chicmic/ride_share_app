//
//  PrimaryButtonLabel.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

struct DefaultButtonLabel: View {
    
    // MARK: - properties
    
    // button text
    var text: String
    
    // boolean to check if the button is primary or not
    // by default set to `true`
    var isPrimary: Bool = true
    
    var color: Color = Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary))
    
    // MARK: - body
    
    var body: some View {
        
        // button text
        Text(text)
            .frame(maxWidth: .infinity)
            .padding()
            .font(.system(size: 16))
            .fontWeight(.semibold)
            // set background by checking `isPrimary` boolean
            .background(
                isPrimary ?
                color : color.opacity(0)
            )
            // set foreground by checking `isPrimary` boolean
            .foregroundColor(
                isPrimary ? .white : color
            )
            .cornerRadius(8)
            .overlay {
                // shown when value of `isPrimary` is set to `false`
                if !isPrimary {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(color, lineWidth: 1)
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
