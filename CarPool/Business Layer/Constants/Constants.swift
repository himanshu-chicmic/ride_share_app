//
//  StringConstants.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import Foundation
import UIKit

struct Constants {
    
    struct TabView {
        static let search = "Search"
        static let searchIcon = "magnifyingglass"
        
        static let rides = "Your Rides"
        static let ridesIcon = "quote.opening"
        
        static let inbox = "Inbox"
        static let inboxIcon = "message"
        
        static let profile = "Profile"
        static let profileIcon = "person.crop.circle"
    }
    
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
        
        static let logIn                    = "Log In"
        static let login                    = "Log in"
        
        static let forgotPassword           = "Forgot password?"
        static let resetPassword            = "Reset Password"
        static let resetPasswordDescription = "Please enter the email you signed up with to confirm reset password"
        static let enterNewPassword         = "Enter a new password"
        
        static let notAMember               = "Not a member yet?"
        
        static let submit                   = "Submit"
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
        static let titles               = ["What's your name?", "What's your mobile number?", "What's your date of birth?", "How'd you like to be addressed?"]
        
        // progress bar properties
        static let progress             = "Step %i of 4"
        
        static let progressCompletion   = 100.0
        static let progressIncrements   = 25.0
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
        static let dateOfBirth      = "yyyy-MM-dd"
        
        // select name prefix
        static let selectGender     = "Select name prefix"
        static let genders          = ["Mr.", "Ms/Mrs.", "I'd prefer not to say"]
        
        static let leavingFrom      = "Leaving from"
        static let goingTo          = "Going to"
        static let today            = "Today"
        static let one              = "1"
        
        static let fullAddress      = "Enter full address"
        
        static let mobile           = "Enter phone number"
        static let bio              = "Add bio"
        
        static let vehicleTitles    = ["Country", "Number", "Brand", "Name of Vehicle", "Vehicle Type", "Color", "Model Year"]
    }
    
    struct Vehicle {
        static let country          = "Select country"
        static let number           = "Registration number"
        static let brand            = "Ex: Toyota"
        static let name             = "Ex: Etios"
        static let type             = "Ex: Sedan, Hatchback etc."
        static let color            = "Select color"
        static let modelYear        = "Select year"
        
        static let headings             = ["Country", "Vehicle number", "Brand", "Model", "Type of vehicle", "Color", "Model year"]
    }
    
    struct Headings {
        
        static let email = "What's your email?"
        static let mobile = "What's your mobile number?"
        static let bio = "What would you like other members to know about you?"
        static let vehicle = "Add vehicle"
        
        static let pickUp = "Pick-up"
        static let dropOff = "Drop-off"
        static let seatsToBook = "Number of seats to book"
        static let whenAreYouGoing = "When are you going?"
    }
    
    struct UserInfo {
        
        static let title        = "Personal details"
        
        static let firstname    = "First name"
        static let lastname     = "Last name"
        static let gender       = "Gender"
        static let dateOfBirth  = "Date of birth"
        static let email        = "Email address"
        static let mobile       = "Mobile phone"
        static let bio          = "Bio"
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
        
        static let email        = "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"
        static let password     = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$"
        static let name         = "[A-Za-z, ]+"
        static let phone        = "^[6-9]\\d{9}$"
    }
    
    // MARK: - validation messages
    struct ValidationMessages {
        
        // email
        static let emailIsEmpty         = "Please enter your email address."
        static let invalidEmail         = "The email address you've entered is invalid."
        
        // phone
        static let phoneIsEmpty         = "Please enter your phone number."
        static let invalidPhone         = "The phone number you've entered is invalid."
        
        // password
        static let passwordIsEmpty      = "Please enter a password."
        static let passwordUnderflow    = "Password must contain 8 characters."
        static let passwordOverflow     = "Password length exceeds max allowed 16 characters."
        static let passwordMustContains = "Password must contain at least one uppercase, one lowercase letter, one digit and one special character."
        
        // confirm password
        static let reEnterPasswordEmpty = "Please re-enter your password."
        static let passwordsMismatch    = "Re-Entered password do not match with the original password."
        
        // name
        static let nameIsEmpty          = "Please enter your name."
        static let invalidName          = "Digits and special characters are not allowed."
        
        // invalid picker selection
        static let invalidNamePrefix    = "Please select your name prefix."
        static let noCountrySelection    = "Please select a country."
        static let noYearSelected    = "Please select build year of your vehicle."
        static let noColorSelected    = "Please select color of your vehicle."
        
        // all input fields required
        static let inputFieldsEmpty = "All input fields are required to be filled for adding a vehicle."
        
        static let emptyStartLocation = "Enter a start location"
        static let emptyEndLocation = "Enter an end location"
    }
    
    // MARK: - other common strings
    struct Others {
        
        static let or           = "OR"
        static let continue_    = "Continue"
        static let back         = "Back"
        static let done         = "Done"
        static let yes          = "Yes"
        static let no           = "No"
        static let save         = "Save"
        static let cancel       = "Cancel"
        static let close       = "Close"
        static let dismiss       = "Dismiss"
        static let exit         = "Exit"
        static let update         = "Update"
    }
    
    struct JsonKeys {
        static let user = "user"
        static let data = "data"
        static let code = "code"
        static let image = "image"
        static let status = "status"
        static let message = "message"

        static let resetPasswordToken = "reset_password_token"
        static let passwordConfirmation = "password_confirmation"
        
        static let sourceLongitude = "source_longitude"
        static let sourceLatitude = "source_latitude"
        static let destinationLongitude = "destination_longitude"
        static let destinationLatitude = "destination_latitude"
        static let passengersCount = "pass_count"
        static let date = "date"
        
        static let places = "PLACES_API_KEY"
        
        static let id = "id"
    }
    
    struct ErrorsMessages {
        static let emailAlreadyExists = "Email already exists."
        
        static let invalidUrl = "URL Invalid"
        
    }
    
    struct InfoMessages {
        static let pictureUpdated = "Profile picture updated!"
    }
    
    struct UserDefaultKeys {
        static let session = "SessionAuthToken"
        static let profileData = "UserProfileData"
        static let vehiclesData = "VehiclesData"
    }
    
    // MARK: - alert dialog strings
    struct AlertDialog {
        
        static let exitCompleteProfile  = "Your account won't be created. Are you sure to exit?"
        
        static let exitPasswordReset    = "You didn't reset your password. Are you sure to go back?"
        
        static let logout    = "Are you sure you want to log out?"
        
        static let areYouSure           = "Are you sure?"
    }
    
    // MARK: - images names
    struct Images {
        
        static let introImage   = "intro-image"
        
        static let defaultImageName = "image.png"
    }
    
    // MARK: - default icons
    struct Icon {
        
        static let close            = "xmark"
        static let back             = "chevron.left"
        static let next             = "chevron.right"
        static let check            = "checkmark"
        static let checkCircle            = "checkmark.circle.fill"
        
        static let edit             = "square.and.pencil"
        static let plusCircle       = "plus.circle"
        static let minusCircle      = "minus.circle"
        
        static let eye              = "eye"
        static let eyeSlash         = "eye.slash"
        
        static let startLocation    = "circle"
        static let endLocation      = "circle"
        
        static let star             = "star.fill"
        
        static let person           = "person"
        static let calendar         = "calendar"
        
        static let enter            = "arrow.up.left"
    }
    
    // MARK: - search view
    struct Search {
        
        static let title    = "Where To?"
        static let search   = "Search"
    }
    
    // MARK: - type aliases
    struct TypeAliases {
        //                                  value, placeholde, identifier, keyboard type
        typealias InputFieldArrayType = [(String, String, InputFieldIdentifier, UIKeyboardType)]
    }
    
    // MARK: - rides data
    struct RidesData {
        
        static let info = "%@ | %@ Seats"
    }
    
    // MARK: - profile buttons
    struct ProfileButtons {
        
        static let verify           = "Verify your profile"
        
        static let about            = "About you"
        
        static let vehicle          = "Vehicles"
        
        static let edit             = "Edit profile"
        
        static let account          = "Account"
    }
    
    // MARK: - profile account
    struct ProfileAccount {
        
        static let ratings              = ["Ratings"]
        static let additionalOptions    = ["Help", "Terms & Conditions", "Data protection", "Licences"]
        static let details              = ["Change password"]
        
        static let logOut               = "Log out"
        
        static let headings             = ["First name", "Last name", "Gender", "Date of birth", "Email address", "Mobile number"]
    }
    
    struct ImagePicker {
        
        static let selectFromGallery = "Select from gallery"
        static let takePicture = "Take picture"
    }
}
