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
    
    /// method to get data in dicionary format. this data used in api request
    /// - Parameters:
    ///   - emailPassword: an array containing email and password data
    ///   - values: an array containing additional text fields data
    ///   - viewModel: view model instace to get input value from there
    /// - Returns: a dictionary of type [String: Any]
    func getData(
        emailPassword   : Constants.TypeAliases.InputFieldArrayType,
        values          : [Constants.TypeAliases.InputFieldArrayType],
        viewModel       : UserDetailsViewModel
    ) -> [String : Any] {
        
        // initialize array with values
        var array = values
        
        // append email and password array
        array.append(emailPassword)
        
        // initialize empty dictinary
        var data: [String: Any] = [:]
        
        // the array here is two dimentional
        // to get value we need two for loops
        for value in array {
            // inner loop get the value from array
            for innerValue in value where innerValue.2 != .confirmPassword {
                // swift over the type of input field
                // some input fields are pickers and their
                // values are stored in user details view model
                // and assign the values accordingly
                switch innerValue.2 {
                case .gender:
                    data[innerValue.2.rawValue] = viewModel.gender
                case .dateOfBirth:
                    data[innerValue.2.rawValue] = Globals.dateFormatter.string(from: viewModel.date)
                default:
                    data[innerValue.2.rawValue] = innerValue.0
                }
            }
        }
        
        // return the final dictionary
        return ["user" : data]
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
