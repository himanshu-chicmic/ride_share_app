//
//  UserDetailsViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI

class DetailsViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: published properties
    @Published var showPicker = false
    @Published var pickerType: PickerFieldIdentifier = .date
    
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
    
    // userDetailsModel for first name,
    // last name, date of birth and,
    // gender properties
    @Published var userModel = UserModel()
    
    // state array to store the values
    // neccessary for the input fields
    @Published var textFieldValues: [Constants.TypeAliases.InputFieldArrayType] = []
    
    // open image picker confirmation
    @Published var editPhoto = false
    // open image picker
    @Published var openPhotosPicker = false
    
    // MARK: computed properties
    // property to get the index value
    // from profileCompletion state var
    // this index is used to get the value
    // from titles array in Constants
    var index: Int {
        Int(profileCompletion/Constants.UserDetails.progressIncrements) - 1
    }
    
    // MARK: arrays
    // array for buttons
    var buttonsArray: [[EditProfileIdentifier]] = [
        [.email, .mobile],
        [.bio],
        [.vehicles]
    ]
    
    // array for title
    var titles: [String] = [
        Constants.ProfileButtons.verify,
        Constants.ProfileButtons.about,
        Constants.ProfileButtons.vehicle
    ]
    
    // MARK: instance variables
    var baseViewModel = BaseViewModel.shared
    
    // MARK: - methods
    
    // MARK: api calling methods
    /// method to validate profile input data
    /// - Parameters:
    ///   - increment: bool value to check whether the next button is clicked (true) or back button is clicked (false)
    ///   - emailPassword: email and password value needed for sign up / creating a new user in database
    func validateProfileData(increment: Bool, emailPassword: Constants.TypeAliases.InputFieldArrayType) {
        withAnimation {
            // check validations while incrementing
            // the complete profile steps
            
            // check for name and phone number validation
            if profileCompletion == 25 || profileCompletion == 50 && increment {
                // check for textfield validations
                baseViewModel.toastMessage = baseViewModel
                    .validationsInstance
                    .validateTextFields(
                        textFields: textFieldValues[index]
                    )
            }
            
            // check for gender
            else if profileCompletion == 100 && increment {
                // check for name prefix validations
                baseViewModel.toastMessage = baseViewModel
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
                // and compeltion value's between 25 and 100
                if baseViewModel.toastMessage.isEmpty
                   && profileCompletion >= 25 && profileCompletion < 100 {
                    // then increment
                    profileCompletion += 25
                } else if baseViewModel.toastMessage.isEmpty && profileCompletion == 100 {
                    
                    // get data in dictionary
                    let data = baseViewModel.getDataInDictionary(
                        emailPassword: emailPassword, values: textFieldValues, viewModel: self
                    )
                    
                    // call signin method
                    baseViewModel.sendRequestToApi(
                        httpMethod  : .POST,
                        requestType : .signUp,
                        data        : data
                    )
                }
                
            } else {
                // when decrement button (back) is pressed
                profileCompletion -= 25
            }
            
        }
    }
    
    func validateCompleteProfile(textFieldValues: Constants.TypeAliases.InputFieldArrayType) {
        withAnimation {
            // check for textfield validations
            baseViewModel.toastMessage = baseViewModel.validationsInstance
                .validateTextFields(textFields: textFieldValues)
            
            if baseViewModel.toastMessage.isEmpty {
                baseViewModel.toastMessage = baseViewModel.validationsInstance
                    .validatePickerSelectedValue(
                        value       : gender,
                        placeholder : Constants.Placeholders.selectGender,
                        error       : Constants.ValidationMessages.invalidNamePrefix
                    )
            }
            
        }
        
        // if toast message is empty
        // there no error in validations and verification
        // then navigate to new view
        if baseViewModel.toastMessage.isEmpty {
            // get data in dictionary
           
            let data = baseViewModel.getDataInDictionary(emailPassword: [], values: [textFieldValues], viewModel: self)
            
            // call signin method
            baseViewModel.sendRequestToApi(
                httpMethod  : .PUT,
                requestType : .updateProfile,
                data        : data
            )
        }
    }
    
    // MARK: utility methods
    /// set picker data if userData is not nil
    func setPickerData() {
        if let data = baseViewModel.userData {
            gender = data.status.data?.title ?? Constants.Placeholders.selectGender
            date = Globals.dateFormatter.date(from: data.status.data?.dob ?? "") ?? Globals.defaultDate
        }
    }
    
    /// method to reset text fields array
    func resetTextFields() {
        textFieldValues = userModel.getInputFields2dArray()
    }
    
    /// method to set the type of picker and toggle value of show picker
    /// - Parameter placeholder: a string value containing placeholder for field
    func setPickerTypeAndTogglePicker(placeholder: String) {
        withAnimation {
            switch placeholder {
            case Constants.Placeholders.selectGender:
                pickerType = .gender
            case Constants.Vehicle.country:
                pickerType = .country
            case Constants.Vehicle.color:
                pickerType = .color
            case Constants.Vehicle.modelYear:
                pickerType = .modelYear
            default:
                pickerType = .date
            }
            
            // toggle show picker
            // to open/show
            showPicker.toggle()
        }
    }
    
    /// method to reset properties
    /// associated with date and gender pickers
    func resetPickerData() {
        profileCompletion = 0.0
        showPicker = false
        date = Globals.defaultDate
        gender = Constants.Placeholders.selectGender
        country = Constants.Vehicle.country
        color = Constants.Vehicle.color
        year = Constants.Vehicle.modelYear
    }
    
}
