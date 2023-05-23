//
//  UserDetailsViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI

class UserDetailsViewModel: ObservableObject {
    
    // MARK: - properties
    
    // picker variables
    @Published var showPicker = false
    @Published var pickerType: PickerType = .date
    
    // variable to store date
    // set the default date by
    // difference of 18 years from now
    @Published var date: Date = Globals.defaultDate
    // variable to store gender
    @Published var gender: String = Constants.Placeholders.selectGender
    
    // published var to store vehicle
    // related details from pickers
    @Published var country: String = Constants.Vehicle.country
    @Published var color: String = Constants.Vehicle.color
    @Published var year: String = Constants.Vehicle.modelYear
    
    // progress value for profile completion
    // increments by 30 points
    @Published var profileCompletion = 0.0
    
    // property to get the index value
    // from profileCompletion state var
    // this index is used to get the value
    // from titles array in Constants
    var index: Int {
        Int(profileCompletion/Constants.UserDetails.progressIncrements) - 1
    }
    
    // userDetailsModel for first name,
    // last name, date of birth and,
    // gender properties
    @Published var userDetailsModel = UserDetailsModel()
    
    // state array to store the values
    // neccessary for the input fields
    @Published var textFieldValues: [Constants.TypeAliases.InputFieldArrayType] = []
    
    // instance for validations view model
    var validationsViewModel = ValidationsViewModel.shared
    
    // MARK: - methods
    
    /// method to reset text fields array
    func resetTextFields() {
        textFieldValues = userDetailsModel.getInputFields2dArray()
    }
    
    func validateProfileData(increment: Bool, emailPassword: Constants.TypeAliases.InputFieldArrayType) {
        withAnimation {
            
            // check validations while incrementing
            // the complete profile steps
            
            // check for name
            if profileCompletion == 30 && increment {
                // check for textfield validations
                validationsViewModel.toastMessage = validationsViewModel
                    .validationsInstance
                    .validateTextFields(
                        textFields: textFieldValues[index]
                    )
            }
            
            // check for gender
            else if profileCompletion == 90 && increment {
                // check for name prefix validations
                validationsViewModel.toastMessage = validationsViewModel
                    .validationsInstance
                    .validatePickerSelectedValue(
                        value: gender,
                        placeholder: Constants.Placeholders.selectGender,
                        error: Constants.ValidationMessages.invalidNamePrefix
                    )
            }
            
            // increment button is pressed
            if increment {
                // check if toast message empty
                // and compeltion value's between 30 and 90
                if validationsViewModel.toastMessage.isEmpty
                   && profileCompletion >= 30 && profileCompletion < 90 {
                    // then increment
                    profileCompletion += 30
                } else if !validationsViewModel.toastMessage.isEmpty {
                    // if any error is shown
                    // show if for 3 seconds and
                    // then make it disappear
                    DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                        self.validationsViewModel.toastMessage = ""
                    }
                } else {
                    // call signin method
                    createUser(
                        httpMethod      : .POST,
                        requestType     : .LogIn,
                        emailPassword   : emailPassword
                    )
                }
                
            } else {
                // when decrement button (back) is pressed
                profileCompletion -= 30
            }
            
        }
    }
    
    /// method to call sign in api for creating user
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func createUser(httpMethod: HttpMethod, requestType: RequestType, emailPassword: Constants.TypeAliases.InputFieldArrayType) {
        // set in progress to true for showing loader
        validationsViewModel.inProgess = true
        
        // get data from model
        let data = userDetailsModel.getData(emailPassword: emailPassword)
        
        if requestType == .SignUp {
            validationsViewModel.dismiss = true
        }
        
        // set in progress to false for hiding loader - on response received
        validationsViewModel.inProgess = false
    }
    
    /// method to reset properties
    /// associated with date and gender pickers
    func resetPickerData() {
        showPicker = false
        date = Globals.defaultDate
        gender = Constants.Placeholders.selectGender
        country = Constants.Vehicle.country
        color = Constants.Vehicle.color
        year = Constants.Vehicle.modelYear
    }
    
}
