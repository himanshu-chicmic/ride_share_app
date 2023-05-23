//
//  UserDetailsModel.swift
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
struct UserDetailsModel {
    
    // MARK: - properties
    
    var firstName: String
    var lastName: String
    var gender: String
    var dateOfBirth: String
    var email: String
    var mobile: String
    var bio: String
  
    // MARK: - initializers
    
    /// default initializer to assign values to properties
    init() {
        self.firstName = ""
        self.lastName = ""
        self.gender = ""
        self.dateOfBirth = ""
        self.email = ""
        self.mobile = ""
        self.bio = ""
    }
    
    // MARK: - methods
    
    func getData(emailPassword: Constants.TypeAliases.InputFieldArrayType) -> [String : Any] {
        return [
            "user": [
                "email"         : emailPassword[0].0,
                "password"      : emailPassword[1].0,
                "first_name"    : self.firstName,
                "last_name"     : self.lastName,
                "dob"           : self.dateOfBirth,
                "title"         : self.gender
            ]
        ]
    }
    
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
            // array for date of birth field
            [
                (dateOfBirth, Constants.Placeholders.dateOfBirth, InputFieldIdentifier.dateOfBirth, UIKeyboardType.numberPad)
            ],
            // array for gender field
            [
                (gender, Constants.Placeholders.genders[0], InputFieldIdentifier.gender, UIKeyboardType.default)
            ]
        ]
        
    }
    
    /// method to get the textFieldValues with input value, placeholder value,
    /// input field identifier, and keyboard type
    /// - Returns: return an array containg all the data of input fields
    func getInputFields() -> Constants.TypeAliases.InputFieldArrayType {
        
        // return the array with necessary
        // values of input fields
        return [
            (
                firstName,
                Constants.Placeholders.firstname,
                InputFieldIdentifier.firstName,
                UIKeyboardType.default
            ),
            (
                lastName,
                Constants.Placeholders.lastname,
                InputFieldIdentifier.lastName,
                UIKeyboardType.default
            ),
            (
                gender,
                Constants.Placeholders.selectGender,
                InputFieldIdentifier.gender,
                UIKeyboardType.default
            ),
            (
                dateOfBirth,
                Constants.Placeholders.dateOfBirth,
                InputFieldIdentifier.dateOfBirth,
                UIKeyboardType.default
            ),
            (
                email,
                Constants.Placeholders.email,
                InputFieldIdentifier.email,
                UIKeyboardType.emailAddress
            ),
            (
                mobile,
                Constants.Placeholders.mobile,
                InputFieldIdentifier.mobile,
                UIKeyboardType.numberPad
            )
        ]
        
    }
}
