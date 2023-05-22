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
    
    // MARK: - methods
    
    func signIn(data: [String: Any], httpMethod: HttpMethod, requestType: RequestType) {
        // set in progress to true for showing loader
        ValidationsViewModel.shared.inProgess = true
        
        if requestType == .SignUp {
            ValidationsViewModel.shared.dismiss = true
        }
        
        // set in progress to false for hiding loader - on response received
        ValidationsViewModel.shared.inProgess = false
    }
}
