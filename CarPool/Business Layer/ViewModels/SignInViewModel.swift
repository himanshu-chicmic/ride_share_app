//
//  SignInViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/11/23.
//

import Foundation

class SignInViewModel: ObservableObject {
    
    // MARK: - properties
    
    // published variable for isNewUser
    // determines sign up or log in
    @Published var isNewUser: Bool = true
    
    // returns appbar title
    // for sign in view
    var appBarTitle: String{
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
    
}
