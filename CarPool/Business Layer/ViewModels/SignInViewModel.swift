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
    
    // published variable for isNewUser
    // determines sign up or log in
    @Published var isNewUser: Bool = true
    
    // picker variables
    @Published var showDatePicker = false
    @Published var showGenderPicker = false
    
    // variable to store date
    @Published var date: Date = Date.now
    // variable to store gender
    @Published var gender: String = Constants.Placeholders.selectGender
    
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
    
    // validations struct instance
    var validationsInstance = Validations()
    
    // published var for error/validaton messages
    @Published var toastMessage: String = ""
    
    // MARK: - methods
    
    /// method to reset properties
    /// associated with date and gender pickers
    func resetPickerData() {
        showDatePicker = false
        showGenderPicker = false
        date = Date.now
        gender = Constants.Placeholders.selectGender
    }
    
    /// method to show/hide gender picker
    /// - Parameter show: boolean value, show when true and hide when false
    func showHideGenderPicker(show: Bool) {
        withAnimation {
            showGenderPicker = show
        }
    }
    
    /// method to show/hide date picker
    /// - Parameter show: boolean value, show when true and hide when false
    func showHideDatePicker(show: Bool) {
        withAnimation {
            showDatePicker = show
        }
    }
}
