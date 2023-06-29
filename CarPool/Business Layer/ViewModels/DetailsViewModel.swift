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
    @Published var date: Date = Formatters.defaultDate
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
    
    /// method to validate add profile options
    /// - Parameters:
    ///   - textField: string value
    ///   - placeholder: placeholder text
    ///   - inputField: input field type
    ///   - keyboardType: type of keyboard used
    ///   - otp: otp value
    func validateAddProfileOptions(textField: String, placeholder: String, inputField: InputFieldIdentifier, keyboardType: UIKeyboardType, otp: String) {
        withAnimation {
            // check for textfield validations
            baseViewModel.toastMessage = baseViewModel
                .validationsInstance
                .validateTextFields(
                    textFields: [(
                        textField,
                        placeholder,
                        inputField,
                        keyboardType
                    )]
                )
        }
        
        // if toast message is empty
        // there no error in validations and verification
        if baseViewModel.toastMessage.isEmpty {
            // set new password
            // if new password is set
            // then dismiss the view
            
            if !textField.isEmpty {
                switch inputField {
                case .email:
                    baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .confirmEmail, data: [inputField.rawValue : textField])
                case .phoneNumber:
                    if baseViewModel.viewOtpField {
                        baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .confirmOtp, data: [inputField.rawValue : textField, InputFieldIdentifier.passcode.rawValue : otp])
                    } else {
                        baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .confirmPhone, data: [inputField.rawValue : textField])
                    }
                case .bio:
                    baseViewModel.sendRequestToApi(httpMethod: .PUT, requestType: .updateProfile, data: [Constants.JsonKeys.user:[inputField.rawValue : textField]])
                default:
                    break
                }
            }
        }
    }
    
    /// method to validate and call api for vehicle data
    /// - Parameters:
    ///   - textFieldValues: text input values array
    ///   - vehiclesData: data for VehiclesDataClass
    func validateCompleteVehicleInfo(textFieldValues: Constants.TypeAliases.InputFieldArrayType, vehiclesData: VehiclesDataClass?) {
        // check for textfield validations
        if baseViewModel.toastMessage.isEmpty {
            baseViewModel.toastMessage = baseViewModel.validationsInstance
                .validatePickerSelectedValue(
                    value       : country,
                    placeholder : Constants.Vehicle.country,
                    error       : Constants.ValidationMessages.noCountrySelection
                )
        }
        if baseViewModel.toastMessage.isEmpty {
            baseViewModel.toastMessage = baseViewModel.validationsInstance
                .validatePickerSelectedValue(
                    value       : color,
                    placeholder : Constants.Vehicle.color,
                    error       : Constants.ValidationMessages.noColorSelected
                )
        }
        if baseViewModel.toastMessage.isEmpty {
            baseViewModel.toastMessage = baseViewModel.validationsInstance
                .validatePickerSelectedValue(
                    value       : year,
                    placeholder : Constants.Vehicle.modelYear,
                    error       : Constants.ValidationMessages.noYearSelected
                )
        }
        baseViewModel.toastMessage = baseViewModel
            .validationsInstance
            .validateTextFields(textFields: textFieldValues)
        
        if baseViewModel.toastMessage.isEmpty {
            var data: [String: Any] = [:]
            
            for item in textFieldValues {
                switch item.2 {
                case .country:
                    data[item.2.rawValue] = Constants.Defaults.country
                case .vehicleColor:
                    data[item.2.rawValue] = color
                case .vehicleModelYear:
                    data[item.2.rawValue] = year
                default:
                    data[item.2.rawValue] = item.0
                }
            }
            
            if let vehiclesData {
                baseViewModel.sendVehiclesRequestToApi(httpMethod: .PUT, requestType: .updateVehicle, data: [Constants.JsonKeys.vehicle : data, Constants.JsonKeys.id : vehiclesData.id])
            } else {
                baseViewModel.sendVehiclesRequestToApi(httpMethod: .POST, requestType: .vehicles, data: [Constants.JsonKeys.vehicle : data])
            }
        }
    }
    
    /// validate profile data and send api request
    /// - Parameter textFieldValues: array containing text field values
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
    
    /// set data for add options
    /// - Parameter heading: heading of page in string
    /// - Returns: a string value of data
    func setAddOptionsData(heading: String) -> String {
        switch heading {
        case Constants.Headings.email:
            return baseViewModel.userData?.status.data?.email ?? ""
        case Constants.Headings.mobile:
            return baseViewModel.userData?.status.data?.phoneNumber ?? ""
        case Constants.Headings.bio:
            return baseViewModel.userData?.status.data?.bio ?? ""
        default:
            return ""
        }
    }
    
    /// set picker data if userData is not nil
    func setPickerData(vehiclesData: VehiclesDataClass? = nil) {
        if let data = baseViewModel.userData {
            gender = data.status.data?.title ?? Constants.Placeholders.selectGender
            date = Formatters.dateFormatter.date(from: data.status.data?.dob ?? "") ?? Formatters.defaultDate
        }
        if let data = vehiclesData {
            country = data.country
            color = data.vehicleColor
            year = Formatters.yearString(at: data.vehicleModelYear)
        }
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
        date = Formatters.defaultDate
        gender = Constants.Placeholders.selectGender
        country = Constants.Vehicle.country
        color = Constants.Vehicle.color
        year = Constants.Vehicle.modelYear
    }
    
    /// method to reset text fields array
    func resetTextFields() {
        textFieldValues = userModel.getInputFields2dArray()
    }
    
}
