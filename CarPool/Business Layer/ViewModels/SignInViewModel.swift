//
//  SignInViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import Foundation
import SwiftUI

/// view model for signin properties and methods
class SignInViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: published properties
    // variable that determines sign up or log in
    @Published var isNewUser: Bool = false
    
    // signInModel for email, password and,
    // confirm password properties
    @Published var signInModel = SignInModel()
    
    // array to store the values
    // neccessary for the input fields
    @Published var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // MARK: instance variables
    var baseViewModel = BaseViewModel.shared
    
    // MARK: computed properties
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
    
    // MARK: - methods
    
    // MARK: api calling methods
    /// method to initiate sign in process
    /// by checking the validations first
    /// and then sending the request to api
    func initiateSignIn() {
        withAnimation {
            // check for textfield validations
            baseViewModel.toastMessage = isNewUser
            ?
            // if new user check for confirm password
            // matches original password entered
            baseViewModel
                .validationsInstance
                .validateTextFields(
                    textFields : textFieldValues,
                    count      : textFieldValues.count - 2
                )
            :
            // else check without confirm password
            baseViewModel
                .validationsInstance
                .validateTextFields(textFields: textFieldValues)
        }
        
        // if toast message is empty
        // there no error in validations and verification
        // then navigate to new view
        if baseViewModel.toastMessage.isEmpty {
            // http method
            let httpMethod: HttpMethod = isNewUser ? .GET : .POST
            // request type
            let requestType: RequestType = isNewUser ? .emailCheck : .logIn
            // get data in dictionary
            let data = baseViewModel.getDataInDictionary(values: textFieldValues, type: requestType)
            
            // call sendRequestToApi method
            baseViewModel.sendRequestToApi(
                httpMethod  : httpMethod,
                requestType : requestType,
                data        : data
            )
        }
    }
    
    // MARK: utility methods
    /// method to update text fields
    /// when login signup modes are switched
    func resetTextFields() {
        textFieldValues = signInModel.getInputFields(isNewUser: isNewUser)
    }
}
