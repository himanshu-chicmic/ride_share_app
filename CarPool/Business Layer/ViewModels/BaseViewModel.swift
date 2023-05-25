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
    
    // navigate or dismiss variables
    @Published var navigate: Bool = false
    @Published var dismiss: Bool = false
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @Published var navigateToDashboard: Bool = false
    
    // open view for user detials
    @Published var openUserDetailsView: Bool = false
    
    // open forgot password view
    @Published var openForgotPasswordView: Bool = false
    
    // MARK: variable instances
    // instance for validations struct
    var validationsInstance = Validations()
    
    // MARK: computed properties
    // check logged in status
    // to let the view switch
    // between dashboard or content view
    var loggedInStatus: Bool {
        // get session authorization token from user defaults
        guard let token = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.session) as? String else {
            // return false if not found
            return false
        }
        
        // return false in empty
        if token.isEmpty {
            return false
        }
        
        // return true if found
        return true
    }
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
            switch completion {
            case .failure(let error):
                self.toastMessage = error.localizedDescription
                print("ERROR: \(error)")
            case .finished:
                print("success")
            }
            
            self.disableProgress()
        } receiveValue: { [weak self] dataResponse in
            
            self?.baseDataModel = dataResponse
            
            print(dataResponse)
            
            switch requestType {
            case .logIn:
                self?.goToDashboard()
            case .signUp:
                self?.dismiss = true
                self?.goToDashboard()
            case .emailCheck:
                switch dataResponse.status.code {
                case 0:
                    self?.goToUserDetails()
                case 50...55:
                    self?.toastMessage = "Email already exists."
                default:
                    self?.toastMessage = "Data returned in invalid format."
                }
            case .forgotPassword:
                break
            case .resetPassword:
                break
            case .updateProfile:
                break
            case .confirmEmail:
                break
            case .confirmPhone:
                break
            case .confirmOtp:
                break
            default:
                break
            }
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
                "password_confirmation" : values[1].0,
            ]]

        }
        else if type == .emailCheck || type == .forgotPassword {
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
    /// method to close user details view and
    /// navigate to dashboard by setting the value
    /// of naviate to dashboard to true
    func toggleDetailsViewAndNavigate() {
        // toggle open user details
        openUserDetailsView = false
        // set navigateToDashboard to true
        navigateToDashboard = true
    }
    
    /// method to navigate to dashboard view
    func goToDashboard() {
        // toggle navigate to dashboard
        // changing this will activate is presented
        // inside view and navigate to dashboard
        navigateToDashboard.toggle()
    }
    
    /// method to open user details view
    func goToUserDetails() {
        // toggle open user details
        // changing this will activate is presented
        // inside view and open user details view
        openUserDetailsView.toggle()
    }
}
