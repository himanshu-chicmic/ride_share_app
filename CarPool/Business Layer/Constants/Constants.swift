//
//  StringConstants.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import Foundation
import UIKit

struct Constants {
    
    // MARK: - onboarding
    struct Onboarding {
        
        static let title = "Your pick of rides at low prices"
    }
    
    // MARK: - sign in with
    struct SignInWith {
        
        static let signInWith   = "%@ with %@"
    }
    
    // MARK: - login
    struct LogIn {
        
        static let logIn        = "Log In"
        static let login        = "Log in"
        
        static let notAMember   = "Not a member yet?"
    }
    
    // MARK: - signup
    struct SignUp {
        
        static let signUp           = "Sign Up"
        static let signup           = "Sign up"
        
        static let createAccount    = "Create Account"
        
        static let alreadyAMember   = "Already a member?"
        static let note             = "By signing up, you agree to our T&Cs and\n acknowledge our Privacy Policy."
    }
    
    // MARK: - user details
    struct UserDetails {
        
        static let title                = "Complete Profile"
        static let titles               = ["What's your name?", "What's your date of birth?", "How'd you like to be addressed?"]
        
        // progress bar properties
        static let progress             = "Step %i of 3"
        
        static let progressCompletion   = 90.0
        static let progressIncrements   = 30.0
    }
    
    // MARK: - text field placholders
    struct Placeholders {
        
        // sign up or login
        static let email            = "Enter email address"
        static let password         = "Enter password"
        static let reEnterPassword  = "Re-enter password"
        
        // name text fields
        static let firstname        = "Enter first name"
        static let lastname         = "Enter last name"
        
        // date of birth picker
        static let dateOfBirth      = "dd/mm/yyyy"
        
        // select name prefix
        static let selectGender     = "Select name prefix"
        static let genders          = ["", "Mr.", "Ms/Mrs.", "Id' prefer not to say"]
    }
    
    // MARK: - empty inbox view
    struct EmptyInboxView {
        static let image    = "empty-inbox-view"
        static let title    = "Your inbox is empty."
        static let caption  = "No messages right now. Book or offer a ride to contact someone and start a new journey."
    }
    
    // MARK: - empty rides view
    struct EmptyRidesView {
        static let image    = "empty-your-ride-view"
        static let title    = "Your future travel plans will appear here."
        static let caption  = "Find the perfect ride from thousands of destinations, or publish to share your travel costs."
    }
    
    // MARK: - predicates
    struct PredicateFormat {
        
        static let selfMatches = "SELF MATCHES %@"
    }
    
    // MARK: - regular expressions
    struct ValidationRegex {
        
        static let email        = "^[a-zA-Z0-9.!$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$"
        static let password     = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&/,`^()-+=_~;:'.])[A-Za-z\\d@$!%*#?&/,`^()-+=_~;:'.]{8,16}$"
        static let name         = "[A-Za-z]+"
    }
    
    // MARK: - validation messages
    struct ValidationMessages {
        
        // email
        static let emailIsEmpty         = "Please enter your email address."
        static let invalidEmail         = "The email address you've entered is invalid."
        
        // password
        static let passwordIsEmpty      = "Please enter a password."
        static let passwordUnderflow    = "Password must contain 8 characters."
        static let passwordOverflow     = "Password length exceeds max allowed 16 characters."
        static let passwordMustContains = "Password must contain at least one letter, one number and one special character."
        
        // confirm password
        static let reEnterPasswordEmpty = "Please re-enter your password."
        static let passwordsMismatch    = "Re-Entered password do not match with the original password."
        
        // name
        static let nameIsEmpty          = "Please enter your name."
        static let invalidName          = "Digits and special characters are not allowed."
        
        // name prefix
        static let invalidNamePrefix    = "Please select your name prefix."
    }
    
    // MARK: - other common strings
    struct Others {
        
        static let or           = "OR"
        static let continue_    = "Continue"
        static let back         = "Back"
        static let done         = "Done"
        static let yes          = "Yes"
        static let no           = "No"
    }
    
    // MARK: - alert dialog strings
    struct AlertDialog {
        
        static let exitCompleteProfile = "Your account won't be created. Are you sure to exit?"
    }
    
    // MARK: - images names
    struct Images {
        
        static let introImage   = "intro-image"
    }
    
    // MARK: - default icons
    struct Icon {
        
        static let close    = "xmark"
        static let back     = "chevron.left"
        
        static let eye      = "eye"
        static let eyeSlash = "eye.slash"
    }
    
    // MARK: - type aliases
    struct TypeAliases {
        
        typealias InputFieldArrayType = [(String, String, InputFieldIdentifier, UIKeyboardType)]
    }
}
