//
//  SignInModel.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import Foundation
import UIKit

/// model struct containing
/// properties for signup and
/// login
/// - email : string value for email address
/// - password : string value for password
/// - reEnterPassword : string value for re entered password (used in sign up onlly)
struct SignInModel {
    
    // MARK: - properties
    
    var email: String
    var password: String
    var reEnterPassword: String
    
    // MARK: - initializers
    
    /// default initializer to assign values to properties
    init() {
        self.email = ""
        self.password = ""
        self.reEnterPassword = ""
    }
    
    // MARK: - methods
    
    /// method to get the textFieldValues with input value, placeholder value,
    /// input field identifier, and keyboard type
    /// - Parameter isNewUser: bool to check if the user is new or existing
    /// - Returns: return an array containg all the data of input fields
    func getInputFields(isNewUser: Bool) -> Constants.TypeAliases.InputFieldArrayType {
        
        // initialize the array with necessary
        // values of input fields
        var textFieldValues = [
            (
                email,
                Constants.Placeholders.email,
                InputFieldIdentifier.email,
                UIKeyboardType.emailAddress
            ),
            (
                password,
                Constants.Placeholders.password,
                InputFieldIdentifier.password,
                UIKeyboardType.twitter
            )
        ]
        
        // if user is new / creating account
        // then append the confirm password field
        if isNewUser {
            textFieldValues
                .append(
                    (
                        reEnterPassword,
                        Constants.Placeholders.reEnterPassword,
                        InputFieldIdentifier.confirmPassword,
                        UIKeyboardType.twitter
                    )
                )
        }
        
        // return the array
        return textFieldValues
    }
}
