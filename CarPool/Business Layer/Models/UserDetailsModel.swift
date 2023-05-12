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
    var dateOfBirth: String
    var gender: String
  
    // MARK: - initializers
    
    /// default initializer to assign values to properties
    init() {
        self.firstName = ""
        self.lastName = ""
        self.dateOfBirth = ""
        self.gender = ""
    }
    
    // MARK: - methods
    
    /// method to get the textFieldValues with input value, placeholder value,
    /// input field identifier, and keyboard type
    /// - Returns: return a 2d array containg all the data of input fields
    func getInputFields() -> [Constants.TypeAliases.InputFieldArrayType] {
        
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
}
