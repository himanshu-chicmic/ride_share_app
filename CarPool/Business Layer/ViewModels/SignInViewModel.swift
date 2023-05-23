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
    
    // varible to get response from api
    @Published var getResponse: GetResponse?
    
    // signInModel for email, password and,
    // confirm password properties
    @Published var signInModel = SignInModel()
    
    // open view for user detials
    @Published var openUserDetailsView: Bool = false
    
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
                    requestType : .SignUp
                )
            } else {
                // call api for login
                signIn(
                    httpMethod  : HttpMethod.POST,
                    requestType : .LogIn
                )
            }
        } else {
            // if any error is shown
            // show if for 3 seconds and
            // then make it disappear
            DispatchQueue.main.asyncAfter(deadline: .now()+3) {
                self.validationsViewModel.toastMessage = ""
            }
        }
    }
    
    /// method to call sign in api for loggin user
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func signIn(httpMethod: HttpMethod, requestType: RequestType) {
        
        // get data from model
        var data: [String: Any] = [:]
        var endPoint = ApiConstants.commonEndpoint

        switch requestType {
        case .SignUp:
            data = signInModel.getEmail()
            endPoint = ApiConstants.checkEmail
        case .LogIn:
            data = signInModel.getData()
        case .LogOut:
            data = [:]
            endPoint = ApiConstants.signOut
        }
        
        cancellables = ApiManager.shared.signInUser(httpMethod: httpMethod, data: data, endPoint: endPoint)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                case .finished:
                    print("success")
                }
            } receiveValue: { [weak self] data in
                self?.getResponse = data
                self?.goToUserDetails()
            }
    }
    
    
    func disableProgress() {
        // set in progress to false for hiding loader - on response received
        validationsViewModel.inProgess = false
    }
    
    func goToUserDetails() {
        disableProgress()
        // for signup directly go to next
        // view after validations
        // because for signup we need more
        // user data before making the call
        // to api
        openUserDetailsView.toggle()
    }
}
