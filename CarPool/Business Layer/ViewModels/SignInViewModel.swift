//
//  SignInViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import Foundation
import SwiftUI
import Combine

/// view model for signin properties and methods
class SignInViewModel: ObservableObject {
    
    // MARK: - properties
    private var cancellables: AnyCancellable?
    
    // signInModel for email, password and,
    // confirm password properties
    @Published var signInModel = SignInModel()
    
    // array to store the values
    // neccessary for the input fields
    @Published var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // published variable for isNewUser
    // determines sign up or log in
    @Published var isNewUser: Bool = false
    
    // returns appbar title
    // for sign in view
    var appBarTitle: String {
        isNewUser ? Constants.SignUp.signUp : Constants.LogIn.logIn
    }
    
    // return button text
    // for sign in button in
    // sign in view
    var signInButtonText: String {
        isNewUser ? Constants.SignUp.createAccount : Constants.Others.continue_
    }
    
    // returns text for showing if
    // user is already a member
    // or a new user
    var alreadyOrNotAMember: String {
        isNewUser ? Constants.SignUp.alreadyAMember : Constants.LogIn.notAMember
    }
    
    // returns sign up or log in
    // string for switching the
    // states between signup and login
    var signUpOrLogIn: String {
        isNewUser ? Constants.LogIn.logIn : Constants.SignUp.signUp
    }
    
    // instance for validations view model
    var validationsViewModel = ValidationsViewModel.shared
    
    // MARK: - methods
    
    /// method to update text fields
    /// when login signup modes are switched
    func resetTextFields() {
        textFieldValues = signInModel.getInputFields(isNewUser: isNewUser)
    }
    
    /// method to initiate sign in process
    /// by checking the validations first
    /// and then sending the request to api
    func initiateSignIn() {
        withAnimation {
            // check for textfield validations
            validationsViewModel.toastMessage = isNewUser
            ?
            // if new user check for confirm password
            // matches original password entered
            validationsViewModel.validationsInstance
                .validateTextFields(
                    textFields  : textFieldValues,
                    count       : textFieldValues.count - 2
                )
            :
            // else check without confirm password
            validationsViewModel.validationsInstance
                .validateTextFields(textFields: textFieldValues)
        }
        
        // if toast message is empty
        // there no error in validations and verification
        // then navigate to new view
        if validationsViewModel.toastMessage.isEmpty {
            if isNewUser {
                // call api for sign up
                signIn(
                    httpMethod  : HttpMethod.GET,
                    requestType : .emailCheck
                )
            } else {
                // call api for login
                signIn(
                    httpMethod  : HttpMethod.POST,
                    requestType : .logIn
                )
            }
        }
    }
    
    /// method to call sign in api for loggin user
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func signIn(httpMethod: HttpMethod, requestType: RequestType) {
        
        // start progess view
        // by setting in Progress to true
        validationsViewModel.inProgess = true
        
        // set data for sending
        var data: [String: Any] = [:]
        // set endpoint for api
        var endPoint = ApiConstants.signIn

        // switch over request type
        // to set data variable with correct
        // values and set endpoints based on
        // the type of request
        switch requestType {
        case .logIn:
            data = signInModel.getData(values: textFieldValues)
        case .emailCheck:
            data = signInModel.getEmail(email: textFieldValues[0].0)
            endPoint = ApiConstants.checkEmail
        default:
            break
        }
        
        // call signInUserMethod in ApiManager class
        cancellables = ApiManager.shared.signInUser(
            httpMethod      : httpMethod,
            dataDictionary  : data,
            endPoint        : endPoint,
            requestType     : requestType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                self.validationsViewModel.toastMessage = error.localizedDescription
                print("ERROR: \(error.localizedDescription)")
            case .finished:
                print("success")
            }
            
            self.validationsViewModel.disableProgress()
        } receiveValue: { [weak self] response in
            switch requestType {
            case .logIn:
                self?.validationsViewModel.goToUserDetails()
            case .emailCheck:
                if response.status.code == 0 {
                    self?.validationsViewModel.goToUserDetails()
                } else {
                    self?.validationsViewModel.toastMessage = "Email already exists."
                }
            default:
                break
            }
        }
    }
}
