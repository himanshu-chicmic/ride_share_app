//
//  StringConstants.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import Foundation
import UIKit

struct Constants {
    
    struct Onboarding {
        
        static let title = "Your pick of rides at\nlow prices"
    }
    
    struct SignInWith {
        
        static let signInWith   = "%@ with %@"
        
        static let facebook     = "Facebook"
        static let apple        = "Apple ID"
    }
    
    struct LogIn {
        
        static let logIn        = "Log In"
        static let login        = "Log in"
        
        static let notAMember   = "Not a member yet?"
    }
    
    struct SignUp {
        
        static let signUp           = "Sign Up"
        static let signup           = "Sign up"
        
        static let createAccount    = "Create Account"
        
        static let alreadyAMember   = "Already a member?"
        static let note             = "By signing up, you agree to our T&Cs and\n acknowledge our Privacy Policy."
    }
    
    struct UserDetails {
        
        static let title                = "Complete Profile"
        static let titles               = ["What's your name?", "What's your date of birth?", "How'd you like to be addressed?"]
        
        static let progress             = "Step %i of 3"
        
        static let progressCompletion   = 90.0
        static let progressIncrements   = 30.0
    }
    
    struct Placeholders {
        
        static let email            = "Enter email address"
        static let password         = "Enter password"
        static let reEnterPassword  = "Re-enter password"
        
        static let firstname        = "Enter first name"
        static let lastname         = "Enter last name"
        
        static let dateOfBirth      = "dd/mm/yyyy"
        
        static let gender           = ["Mr.", "Ms/Mrs.", "Id' prefer not to say"]
    }
    
    struct Others {
        
        static let or           = "OR"
        static let continue_    = "Continue"
        static let back         = "Back"
    }
    
    struct Images {
        
        static let introImage   = "intro-image"
    }
    
    struct Icon {
        
        static let close    = "xmark"
        static let back     = "chevron.left"
        
        static let eye      = "eye"
        static let eyeSlash = "eye.slash"
    }
    
    struct TypeAliases {
        
        typealias InputFieldArrayType = [(String, String, InputFieldIdentifier, UIKeyboardType)]
    }
}
