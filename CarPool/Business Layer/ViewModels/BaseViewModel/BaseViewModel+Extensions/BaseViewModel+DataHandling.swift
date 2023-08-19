//
//  BaseViewModel+DataHandling.swift
//  CarPool
//
//  Created by Himanshu on 6/3/23.
//

import Foundation
import SwiftUI

extension BaseViewModel {
    
    // MARK: data handling methods
    
    /// base method to handle data response returned from api. this method checks the type of request
    /// and calls methods, assign variables and toggle navigation variables for changing view
    /// - Parameters:
    ///   - response: response returned from api call
    ///   - type: type of api request
    func handleDataResponse(userData: SignInAndProfileModel? = nil, vehiclesData: VehiclesDataModel? = nil, type: RequestType) {
        switch type {
        case .logIn, .signUp, .logOut:
            // handle response for signup, login and logout
            switchDashboardOnboarding(
                response : userData!,
                type     : type
            )
        case .emailCheck:
            // open details view for getting user information
            openUserDetailsView.toggle()
        case .confirmPhone:
            // show otp field on completino of api call for sending passcode
            withAnimation {
                viewOtpField.toggle()
            }
            toastMessageBackground = .green
            toastMessage = "You'll receive a call for otp."
        case .confirmOtp:
            // close add profile view
            openAddProfile.toggle()
            
            toastMessageBackground = .green
            toastMessage = userData?.status.message ?? "Verified successfully!"
            viewOtpField = false
            // send request to fetch user details to get updated data
            sendRequestToApi(
                httpMethod  : .GET,
                requestType : .getDetails,
                data        : [:]
            )
        case .confirmEmail:
            // close add profile view
            openAddProfile.toggle()
            toastMessageBackground = .green
            toastMessage = userData?.status.message ?? "Verification email sent on your registered email!"

        case .getDetails:
            if vehiclesData == nil {
                sendVehiclesRequestToApi(
                    httpMethod  : .GET,
                    requestType : .getVehicles,
                    data        : [:]
                )
            }
        case .updateProfile:
            // set bools related to open edit profile
            // and open add profile false
            editProfile = false
            openAddProfile.toggle()
            // send request to fetch user details to get updated data
            sendRequestToApi(
                httpMethod  : .GET,
                requestType : .getDetails,
                data        : [:]
            )
        case .uploadImage:
            // set message for success in image updation
            toastMessageBackground = .green
            toastMessage = Constants.InfoMessages.pictureUpdated
            // send request to fetch user details to get updated data
            sendRequestToApi(
                httpMethod  : .GET,
                requestType : .getDetails,
                data        : [:]
            )
        case .vehicles, .updateVehicle, .deleteVehicle:
            // set add vehicles to false to close add vehicle view
            addVehicle = false
            // sent an api request to fetch vehicles data again
            sendVehiclesRequestToApi(
                httpMethod  : .GET,
                requestType : .getVehicles,
                data        : [:]
            )
        case .getVehicleById:
            self.singleVehicleData = vehiclesData
        default:
            break
        }
    }
    
    /// method to handle data from forgot password api response.
    /// - Parameters:
    ///   - response: response returned from api.
    ///   - requestType: type of api request
    func handleForgotPasswordData(response: ForgotPasswordModel, requestType: RequestType) {
        withAnimation {
            if response.code == 200 {
                if requestType == .sendOtpEmail {
                    self.requestTypeForgotPassword = .emailOtpVerify
                }
                if requestType == .emailOtpVerify {
                    self.requestTypeForgotPassword = .resetPassword
                }
                if requestType == .resetPassword {
                    self.openForgotPassword = false
                }
            }
        }
        if let message = response.message {
            self.toastMessageBackground = .green
            self.toastMessage = message
        }
        if let error = response.error {
            self.toastMessageBackground = .red
            self.toastMessage = error
        }
    }
    
    // MARK: data creation methods
    /// method to get data in dictionary format
    /// this data is sent to api
    /// - Parameter values: an array containing required values for generating a dictionary data
    /// - Returns: a dictionary of type [String: Any]
    func getDataInDictionary(values: Constants.TypeAliases.InputFieldArrayType, type: RequestType) -> [String : Any] {
        // initialize empty dictionary
        var data: [String: Any] = [:]
        
        if type == .emailCheck {
            // if type is email check
            // then we only need email
            // in format:
            // { "email" : "email_of_user" }
            // email is the first field in the values array
            // thus values[0].2.rawValue returns the input type ex. email in string
            // and values[0].0 returns the value of email
            return [values[0].2.rawValue : values[0].0]
        } else {
            // loop over values and create dictionary data
            for value in values where value.2 != .confirmPassword {
                data[value.2.rawValue] = value.0
            }
        }
        // return final result
        return [Constants.JsonKeys.user : data]
    }
    
    /// method to get data in dictionary format. this data used in api request
    /// - Parameters:
    ///   - emailPassword: an array containing email and password data
    ///   - values: an array containing additional text fields data
    ///   - viewModel: view model instace to get input value from there
    /// - Returns: a dictionary of type [String: Any]
    func getDataInDictionary(
        emailPassword   : Constants.TypeAliases.InputFieldArrayType,
        values          : [Constants.TypeAliases.InputFieldArrayType],
        viewModel       : DetailsViewModel
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
                    data[innerValue.2.rawValue] = Formatters.dateFormatter.string(from: viewModel.date)
                default:
                    data[innerValue.2.rawValue] = innerValue.0
                }
            }
        }
        // return the final dictionary
        return [Constants.JsonKeys.user : data]
    }
    
    
    /// method to initiate set new password/reset password
    /// - Parameter data: text field values
    func setNewPassword(data: Constants.TypeAliases.InputFieldArrayType) {
        toastMessageBackground = .red
        
        var values = data
        values.removeFirst()
        values.removeFirst()
        
        withAnimation {
            toastMessage = validationsInstance.validateTextFields(
                textFields : values
            )
        }
        
        if toastMessage.isEmpty {
            createFogotPasswordApiCall(
                httpMethod: .POST,
                requestType: .resetPassword,
                data: [Constants.JsonKeys.email: data[0].0.lowercased(), Constants.JsonKeys.password: data[2].0, Constants.JsonKeys.passwordConfirmation: data[3].0]
            )
        }
    }
}
