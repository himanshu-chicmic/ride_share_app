//
//  UserModel.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import Foundation
import UIKit

/// model struct containing
/// properties for user details
/// - firstName : string value for first name
/// - lastName : string value for last name
/// - dateOfBirth : string value for date
/// - gender : string value for user gender
struct UserModel {
    
    // MARK: - properties
    
    var firstName: String
    var lastName: String
    var email: String
    var mobile: String
  
    // MARK: - initializers
    
    /// default initializer to assign values to properties
    init() {
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.mobile = ""
    }
    
    // MARK: - methods
    
    /// method to get the textFieldValues with input value, placeholder value,
    /// input field identifier, and keyboard type
    /// - Returns: return a 2d array containg all the data of input fields
    func getInputFields2dArray() -> [Constants.TypeAliases.InputFieldArrayType] {
        
        // return the array with necessary
        // values of input fields
        return [
            // array for first name and last name field
            [
                (firstName, Constants.Placeholders.firstname, InputFieldIdentifier.firstName, UIKeyboardType.default),
                (lastName, Constants.Placeholders.lastname, InputFieldIdentifier.lastName, UIKeyboardType.default)
            ],
            // array for phone number
            [
                (mobile, Constants.Placeholders.mobile, InputFieldIdentifier.phoneNumber, UIKeyboardType.numberPad)
            ],
            // array for date of birth field
            [
                ("", Constants.Placeholders.dateOfBirth, InputFieldIdentifier.dateOfBirth, UIKeyboardType.numberPad)
            ],
            // array for gender field
            [
                ("", Constants.Placeholders.genders[0], InputFieldIdentifier.gender, UIKeyboardType.default)
            ]
        ]
        
    }
    
    /// method to get the textFieldValues with input value, placeholder value,
    /// input field identifier, and keyboard type
    /// - Returns: return an array containg all the data of input fields
    func getInputFields(data: SignInAndProfileModel?) -> Constants.TypeAliases.InputFieldArrayType {
        
        // return the array with necessary
        // values of input fields
        return [
            (
                data?.status.data?.firstName ?? firstName,
                Constants.Placeholders.firstname,
                InputFieldIdentifier.firstName,
                UIKeyboardType.default
            ),
            (
                data?.status.data?.lastName ?? lastName,
                Constants.Placeholders.lastname,
                InputFieldIdentifier.lastName,
                UIKeyboardType.default
            ),
            (
                "",
                Constants.Placeholders.selectGender,
                InputFieldIdentifier.gender,
                UIKeyboardType.default
            ),
            (
                "",
                Constants.Placeholders.dateOfBirth,
                InputFieldIdentifier.dateOfBirth,
                UIKeyboardType.default
            ),
            (
                data?.status.data?.email ?? email,
                Constants.Placeholders.email,
                InputFieldIdentifier.email,
                UIKeyboardType.emailAddress
            ),
            (
                data?.status.data?.phoneNumber ?? mobile,
                Constants.Placeholders.mobile,
                InputFieldIdentifier.phoneNumber,
                UIKeyboardType.numberPad
            )
        ]
        
    }
}
