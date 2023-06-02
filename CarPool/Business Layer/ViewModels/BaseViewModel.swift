//
//  BaseViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: static shared instance
    static let shared = BaseViewModel()
    
    // MARK: private properties
    private var cancellables: AnyCancellable?
    
    // MARK: published properties
    // variable to get response from api
    @Published var baseDataModel: SignInAndProfileModel?
    
    // var for error/validaton messages
    // to be shown on a error dialog box
    @Published var toastMessage: String = "" {
        // did set property
        // observers any changes in toastMessage property
        didSet {
            // if toast message is not empyt
            if !toastMessage.isEmpty {
                // call dismiss method for toast
                dismissToastInThreeSeconds()
            }
        }
    }
    
    // var to know if the screen is processing
    // information and show a progress view
    @Published var inProgess: Bool = false
    
    // open view for user detials
    @Published var openUserDetailsView: Bool = false
    
    // open edit details for vehicles or profile
    @Published var editProfile = false
    @Published var addVehicle = false
    
    // open forgot password view
    @Published var openForgotPasswordView: Bool = false
    
    // update single profile item
    @Published var openAddProfile: Bool = false
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @Published var switchToDashboard = false
    
    @Published var viewOtpField = false
    
    // MARK: variable instances
    // instance for validations struct
    var validationsInstance = Validations()
    
    // MARK: computed properties
    var userData: SignInAndProfileModel? {
        // get session authorization token from user defaults
        guard let data = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.profileData) as? Data else {
            // return false if not found
            return nil
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(SignInAndProfileModel.self, from: data) else {
            return nil
        }
        
        return loadedData
    }
    
    // MARK: - methods
    
    // MARK: method to send api requests
    /// method to send api request and observe changes
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestToApi(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        // set in progress to true for showing loader
        inProgess = true
        // call signInUserMethod in ApiManager class
        cancellables = ApiManager.shared.createApiRequest(
            httpMethod      : httpMethod,
            dataDictionary  : data,
            requestType     : requestType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            // switch completion to handle
            // failure and finished cases
            switch completion {
            case .failure(let error):
                self.toastMessage = error.localizedDescription
                print("ERROR: \(error)")
            case .finished:
                print("success")
            }
            
            // disable the progress view once the completion has received
            self.disableProgress()
        } receiveValue: { [weak self] response in
            
            // if response is success set data to user defaults
            if response.status.code == 200, requestType != .confirmOtp, requestType != .confirmPhone, requestType != .confirmEmail {
                self?.baseDataModel = response
            }
            
            if response.status.code == 200 {
                // call function handleDataRespones to handle
                // the result returned from api
                self?.handleDataResponse(response: response, type: requestType)
            } else {
                self?.toastMessage = response.status.error ?? response.status.message ?? ""
            }
        }
    }
    
    // MARK: methods for handling data from the api
    /// method to check the response status code for email check api requeste
    /// - Parameter response: a response retured from the api call
    func handleEmailCheckResponse(response: SignInAndProfileModel) {
        // check status code for email check
        switch response.status.code {
        // status code 0 is indication that the email is
        // available to use and users can proceed to enter
        // their personal information
        case 0:
            // open user details page
            openUserDetailsView.toggle()
        // else the email already
        // exists in the database and cannot be used again
        default:
            // set toast message for dupliation of email address
            toastMessage = "Email already exists."
        }
    }
    
    /// method to handle reponse for login, signup and logout
    /// - Parameter response: response returned from api call
    func switchDashboardOnboarding(response: SignInAndProfileModel) {
        if openUserDetailsView {
            openUserDetailsView.toggle()
        }
        switchToDashboard.toggle()
    }
    
    /// base method to handle data response returned from api. this method checks the type of request
    /// and calls methods, assign variables and toggle navigation variables for changing view
    /// - Parameters:
    ///   - response: response returned from api call
    ///   - type: type of api request
    func handleDataResponse(response: SignInAndProfileModel, type: RequestType) {
        // check the type of the request and handle the response
        // accroding to the type of request
        switch type {
        case .logIn, .signUp, .logOut:
            // handlre response for signup, login and logout
            switchDashboardOnboarding(response: response)
        case .emailCheck:
            // handle email check response by checking
            // the status code of the response indside
            // handleEmailCheckResponse
            handleEmailCheckResponse(response: response)
        case .updateProfile:
            if editProfile {
                editProfile.toggle()
            }
            if openAddProfile {
                openAddProfile.toggle()
            }
        case .uploadImage:
            toastMessage = "Profile picture updated!"
        case .confirmPhone:
            withAnimation {
                viewOtpField.toggle()
            }
        case .confirmOtp:
            sendRequestToApi(httpMethod: .GET, requestType: .getDetails, data: [:])
            openAddProfile.toggle()
            viewOtpField.toggle()
        default:
            break
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
        
        if type == .resetPassword {
            // return dictinary according to
            // reset password
            // needs reset password token and new password
            return [Constants.JsonKeys.user : [
                "reset_password_token": "returned from api",
                values[1].2.rawValue : values[1].0,
                "password_confirmation" : values[1].0
            ]]

        } else if type == .emailCheck || type == .forgotPassword {
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
                print(innerValue.2.rawValue)
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
        return [Constants.JsonKeys.user : data]
    }
    
    // MARK: methods for view components
    /// method to dismiss toast message by
    /// setting it's value to empyt in three seconds
    /// from the time it's been set with a message
    func dismissToastInThreeSeconds() {
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.toastMessage = ""
            }
        }
    }
    
    /// method to disable progress bar state
    func disableProgress() {
        // set in progress to false for hiding loader - on response received
        inProgess = false
    }
    
    // MARK: change navigation methods
    func switchDashboardLogin() {
        // get session authorization token from user defaults
        if let token = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.session) as? String {
            // return false if not found
            switchToDashboard = !token.isEmpty
        }
    }
}
