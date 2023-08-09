//
//  SignInViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: published properties
    
    // sign up or log in
    @Published var isNewUser: Bool = false
    // navigate to login signup
    @Published var navigate: Bool = false
    
    // signInModel instance
    @Published var signInModel = SignInModel()
    
    // array to store input fields
    @Published var textFieldValues: Constants.TypeAliases.InputFieldArrayType = []
    
    // MARK: instance variables
    var baseViewModel = BaseViewModel.shared
    
    // MARK: computed properties
    
    // appbar title
    var appBarTitle: String {
        isNewUser ? Constants.SignUp.signUp : Constants.LogIn.logIn
    }
    
    // returns text for already a member or a new user
    var alreadyOrNotAMember: String {
        isNewUser ? Constants.SignUp.alreadyAMember : Constants.LogIn.notAMember
    }
    
    // returns sign up or log in string
    var signUpOrLogIn: String {
        isNewUser ? Constants.LogIn.logIn : Constants.SignUp.signUp
    }
    
    // MARK: - methods
    
    // MARK: api calling methods
    
    /// method to initiate sign in process
    func initiateSignIn() {
        baseViewModel.toastMessageBackground = .red
        withAnimation {
            baseViewModel.toastMessage = isNewUser
            ?
            baseViewModel
                .validationsInstance
                .validateTextFields(
                    textFields : textFieldValues,
                    count      : textFieldValues.count - 2
                )
            :
            baseViewModel
                .validationsInstance
                .validateTextFields(textFields: textFieldValues)
        }
        
        if baseViewModel.toastMessage.isEmpty {
            let httpMethod: HttpMethod = isNewUser ? .GET : .POST
            let requestType: RequestType = isNewUser ? .emailCheck : .logIn
            let data = baseViewModel.getDataInDictionary(values: textFieldValues, type: requestType)
        
            baseViewModel.sendRequestToApi(
                httpMethod  : httpMethod,
                requestType : requestType,
                data        : data
            )
        }
    }
    
    /// method to initiate fogot password
    /// - Parameters:
    ///   - textFieldValues: input field values
    ///   - isNavigated: bool to check if the view is navigated, used for validation of fields
    func initiateForgotPassword(textFieldValues: Constants.TypeAliases.InputFieldArrayType, isNavigated: Bool) {
        baseViewModel.toastMessageBackground = .red
        withAnimation {
            // validate text fields
            baseViewModel.toastMessage = navigate
            ? baseViewModel.validationsInstance.validateTextFields(
                textFields : textFieldValues,
                count      : textFieldValues.count - 2
            )
            : baseViewModel.validationsInstance.validateTextFields(textFields: textFieldValues)
        }
        
        if baseViewModel.toastMessage.isEmpty {
            let requestTypeForValidation: RequestType = isNavigated ? .resetPassword : .emailCheck
            let data = baseViewModel.getDataInDictionary(values: textFieldValues, type: requestTypeForValidation)
            baseViewModel.sendRequestToApi(httpMethod: .POST, requestType: .forgotPassword, data: data)
        }
    }
    
    // MARK: utility methods
    
    /// method to update text fields
    /// when login signup modes are switched
    func resetTextFields() {
        textFieldValues = signInModel.getInputFields(isNewUser: isNewUser)
    }
}
