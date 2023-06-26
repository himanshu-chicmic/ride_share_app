//
//  Validations.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import Foundation

/// struct containing valiation methods for all kinds
/// of input fields used in the appliacation
struct Validations {
    
    // MARK: - methods
    
    /// method to return predicate for regex based on
    /// the type of input field
    /// - Parameter type: value for input field identifier
    /// - Returns: predicate expression
    func getPredicate(type: InputFieldIdentifier) -> NSPredicate {
        
        // validation regex struct
        let validationRegex = Constants.ValidationRegex.self
        
        // initialize regEx var with empty string
        var regEx = ""
        
        // switch type of input field identifier
        switch type {
        case .email: regEx = validationRegex.email
        case .password: regEx = validationRegex.password
        case .firstName, .lastName: regEx = validationRegex.name
        case .phoneNumber: regEx = validationRegex.phone
        case .vehicleNumber: regEx = validationRegex.vechileRegistrationNumber
        default: regEx = ""
        }
        
        // return the predicate
        return NSPredicate(format:Constants.PredicateFormat.selfMatches, regEx)
    }
    
    /// method to check if name prefix value is not selected
    /// - Parameter value: value of the name prefix
    /// - Returns: a string value containing toast message
    func validatePickerSelectedValue(value: String, placeholder: String, error: String) -> String {
        
        // check validation conditions
        if value == placeholder {
            return error
        }
        
        // return empty string is
        // all validations are correct
        return ""
    }
    
    /// method to validate name input by the user
    /// - Parameters:
    ///   - value: string value containing name
    ///   - type: type of the input field value
    /// - Returns: a string value containing toast message
    func validateName(value: String, type: InputFieldIdentifier) -> String {
        
        // get the predicate
        let predicate = getPredicate(type: type)
        
        // check validation conditions
        if value.isEmpty {
            return Constants.ValidationMessages.nameIsEmpty
        } else if !value.isEmpty && !predicate.evaluate(with: value) {
            return Constants.ValidationMessages.invalidName
        }
        
        // return empty string is
        // all validations are correct
        return ""
    }
    
    /// method to match re entered password with the original password
    /// - Parameters:
    ///   - reEntered: string value for re entered password
    ///   - password: string value for the original password
    /// - Returns: a string value for toast message
    func matchConfirmPassword(reEntered: String, password: String) -> String {
        
        // check validation conditions
        if reEntered.isEmpty {
            return Constants.ValidationMessages.reEnterPasswordEmpty
        } else if reEntered.elementsEqual(password) {
            return ""
        }
        
        // else return validation message
        return Constants.ValidationMessages.passwordsMismatch
    }
    
    /// method to validate the password input by user
    /// - Parameters:
    ///   - value: string value containing password
    ///   - type: type of the input field
    /// - Returns: a string value for toast message
    func validatePassword(value: String, type: InputFieldIdentifier) -> String {
        
        // get the predicate
        let predicate = getPredicate(type: type)
        
        // check validation conditions
        if value.isEmpty {
            return Constants.ValidationMessages.passwordIsEmpty
        }
        if value.count < 8 {
            return Constants.ValidationMessages.passwordUnderflow
        } else if value.count > 16 {
            return Constants.ValidationMessages.passwordOverflow
        } else if !predicate.evaluate(with: value) {
            return Constants.ValidationMessages.passwordMustContains
        }
        
        // return empty string is
        // all validations are correct
        return ""
    }
    
    /// method to check if text field are not empty
    /// - Parameter value: string value containing email
    /// - Returns: a string value for toast message
    func validateText(value: String) -> String {
        
        // check validation condition
        if value.isEmpty {
            return Constants.ValidationMessages.inputFieldsEmpty
        }
        
        // return empty string is
        // all validations are correct
        return ""
    }
    
    /// method to validate email input by user
    /// - Parameters:
    ///   - value: string value containing email
    ///   - type: type of the input field
    /// - Returns: a string value for toast message
    func validateEmailorPhone(value: String, type: InputFieldIdentifier) -> String {
        
        // get the predicate
        let predicate = getPredicate(type: type)
        
        // check validation conditions
        if value.isEmpty {
            return type == .email
            ? Constants.ValidationMessages.emailIsEmpty
            : Constants.ValidationMessages.phoneIsEmpty
        } else if !predicate.evaluate(with: value) {
            return type == .email
            ? Constants.ValidationMessages.invalidEmail
            : Constants.ValidationMessages.invalidPhone
        }
        
        // return empty string is
        // all validations are correct
        return ""
    }
    
    func validateVehicleNumber(value: String) -> String {
        let predicate = getPredicate(type: .vehicleNumber)
        
        if value.isEmpty {
            return Constants.ValidationMessages.emptyVehicleNumber
        } else if !predicate.evaluate(with: value) {
            return Constants.ValidationMessages.invalidVehicleNumber
        }
        
        return ""
    }
    
    /// main method to check for input field validations
    /// - Parameters:
    ///   - textFields: array of text fields that need to be validated
    ///   - count: an optional value used in checking confirm password against original password
    ///   the count is the index of the text field where original password is stored and it is always one index
    ///   ahead of the confirm password
    /// - Returns: a string value for toast message
    func validateTextFields(textFields: Constants.TypeAliases.InputFieldArrayType, count: Int? = 0) -> String {
        
        // initialize toast message string with empty string
        var toastMessage = ""
        
        // for loop to iterate over the values
        for value in textFields {
            
            // if toast message is not empty
            // return it immediately
            // so the first issue can be
            // shown in the toast message in view
            if !toastMessage.isEmpty {
                return toastMessage
            }
            
            // value.0 - text value of the field
            // value.1 - placeholder value of the field (not used for validations)
            // value.2 - input field type identifier (.email, .password etc.)
            // value.3 - keyboard type (not used for validations)
            switch value.2 {
                // validate for email or phone
            case .email, .phoneNumber:
                toastMessage = validateEmailorPhone(value: value.0, type: value.2)
                
                // valdidate for password
            case .password:
                toastMessage = validatePassword(value: value.0, type: value.2)
                
                // match confirm password with the first password
            case .confirmPassword:
                toastMessage = matchConfirmPassword(reEntered: value.0, password: textFields[count!].0)
                
                // validate name
            case .firstName, .lastName:
                toastMessage = validateName(value: value.0, type: value.2)
                
                // vehicle validations
            case .text:
                toastMessage = validateText(value: value.0)
            case .vehicleNumber:
                toastMessage = validateVehicleNumber(value: value.0)
            default:
                toastMessage = ""
            }
            
        }
        
        // return the toast message
        return toastMessage
    }
    
}
