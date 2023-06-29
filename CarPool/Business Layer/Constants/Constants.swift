//
//  StringConstants.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import Foundation
import UIKit

struct Constants {
    
    struct ButtonText {
        static let openInBrowser = "Open in Browser"
    }
    
    struct Network {
        static let monitor = "NetworkMonitor"
    }
    
    struct Defaults {
        static let defaultUserF = "No"
        static let defaultUserL = "Name"
        
        static let country = "India"
    }
    
    struct DefaultURLs {
        static let stackoverflow = "https://stackoverflow.com"
    }
    
    struct Responses {
        static let profileUpdated = "Profile picture updated!"
    }
    
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
        
        static let rideShare = "Ride Share"
        static let yourRideYourChoice = "Your ride. Your Choice"
        
        static let title = "Welcome to Ride Share"
        static let subTitle = "Let's get started"
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
        
        static let dateFormatterLong = "EEEE, MMMM dd YYYY"
        
        // sign up or login
        static let email            = "Enter email address"
        static let password         = "Enter password"
        static let reEnterPassword  = "Re-enter password"
        
        // name text fields
        static let firstname        = "Enter first name"
        static let lastname         = "Enter last name"
        
        // date formats
        static let dateOfBirth      = "yyyy-MM-dd"
        static let timeFormatter      = "hh:mm a"
        static let dateFormat      = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let localeIdentifier = "en_US_POSIX"
        static let defaultTime = "00:00"
        
        // price
        static let rupee = "Rs. %i"
        
        // select name prefix
        static let selectGender     = "Select name prefix"
        static let genders          = ["Mr.", "Ms/Mrs.", "I'd prefer not to say"]
        
        static let leavingFrom      = "Enter pickup location"
        static let goingTo          = "Enter drop location"
        static let inputLocation    = "Enter a location"
        static let today            = "Today"
        static let one              = "1"
        static let price              = "Enter price per seat"
        static let vehicle              = "Select vehicle"
        
        static let fullAddress      = "Enter full address"
        
        static let mobile           = "Enter phone number"
        static let bio              = "Add bio"
        
        static let vehicleTitles    = ["Country", "Number", "Brand", "Name of Vehicle", "Vehicle Type", "Color", "Model Year"]
        
        static let passcode = "Enter 4-digit passcode"
    }
    
    struct Vehicle {
        static let country          = "Select country"
        static let number           = "Registration number"
        static let brand            = "Ex: Toyota"
        static let name             = "Ex: Etios"
        static let type             = "Ex: Sedan, Hatchback etc."
        static let color            = "Select color"
        static let modelYear        = "Select year"
        
        static let headings             = ["Vehicle number", "Brand", "Model", "Type of vehicle", "Color", "Model year"]
    }
    
    struct Headings {
        
        static let email = "What's your email?"
        static let mobile = "What's your mobile number?"
        static let bio = "What would you like other members to know about you?"
        static let vehicle = "Select a vehicle"
        
        static let rideDetails = "Ride Details"
        
        static let summary = "Summary"
        
        static let pickUp = "Pick-up"
        static let dropOff = "Drop-off"
        static let seatsToBook = "Number of seats"
        static let whenAreYouGoing = "When are you going?"
        static let selectVehicle = "Select a vehicle"
        static let pricePerSeat = "Set price"
    }
    
    struct RideDetails {
        static let totalPrice = "Total price"
        static let contact = "Contact"
        static let shareRide = "Share ride"
        static let details = "Trip info"
        
        static let vehicleDetails = "Vehicle info"
        
        static let passengers = "Passengers"
        static let departureTime = "Departure time"
        static let reachTime = "Reach time"
        static let estimatedTime = "Estimated time"
        static let aboutRide = "About ride"
        static let status = "Ride status"
        
        static let bookRide = "Book Ride"
        static let bookRideForPrice = "Book for %@"
        
        static let timeUnavailable = "No time mentioned"
        static let estimateTimeUnavailable = "couldn't get estimated time."
        static let noRatings = "No ratings"
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
    
    struct NoSearchResults{
        static let image    = "empty-your-ride-view"
        static let title    = "No Rides Found!"
        static let caption  = "Currently, there are no matching rides found. Try again after sometime."
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
        
        static let vechileRegistrationNumber = """
^[A-Z]{2}[\\ -]{0,1}[0-9]{2}[\\ ""-]{0,1}[A-Z]{1,2}[\\ -]{0,1}[0-9]{4}$
"""
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
        
        static let emptyStartLocation = "Enter a start location."
        static let emptyEndLocation = "Enter an end location."
        static let pleaseSelectVehicle = "Please select a vehicle."
        static let pleaseSetPrice = "Please set a price for per seat."
        
        static let invalidVehicleNumber = "Invalid vehicle registration number. Please input correct number."
        static let emptyVehicleNumber = "Please enter your vehicle's registration number."
    }
    
    // MARK: - other common strings
    struct Others {
        
        static let or           = "OR"
        static let continue_    = "Continue"
        static let back         = "Back"
        static let next         = "Next"
        static let done         = "Done"
        static let yes          = "Yes"
        static let no           = "No"
        static let save         = "Save"
        static let cancel       = "Cancel"
        static let close       = "Close"
        static let dismiss       = "Dismiss"
        static let exit         = "Exit"
        static let confirm = "Confirm Ride"
        static let update         = "Update"
        static let clear         = "Clear"
        static let currentLocation = "Set current location"
        static let viewRideDetails = "Ride Details"
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
        static let passengersCount = "passengers_count"
        static let date = "date"
        
        static let country = "country"
        
        static let places = "PLACES_API_KEY"
        
        static let id = "id"
        
        static let vehicle = "vehicle"
        static let publish = "publish"
        
        static let passengers = "passenger"
        static let publishId = "publish_id"
        static let seats = "seats"
        
        static let routes = "routes"
        static let overviewPolyline = "overview_polyline"
        static let points = "points"
        static let legs = "legs"
        static let duration = "duration"
        static let value = "value"
        
        static let source = "source"
        static let destination = "destination"
        static let time = "time"
        static let setPrice = "set_price"
        static let aboutRide = "about_ride"
        static let vehicleId = "vehicle_id"
        static let bookInstantly = "book_instantly"
        static let midSeat = "mid_seat"
        static let estimateTime = "estimate_time"
        static let selectRoute = "select_route"
    }
    
    struct ErrorsMessages {
        static let emailAlreadyExists = "Email already exists."
        
        static let invalidUrl = "URL Invalid"
        
        static let noInternetConnection = "No internet connection available."
        
    }
    
    struct InfoMessages {
        static let pictureUpdated = "Profile picture updated!"
        static let rideCreatedSuccessfuly = "Ride created successfully"
        static let successfullyPublished = "You'r ride is successfully published. ✅"
        static let successPubishedCaption = "Relax, sit back and wait for people to book your ride."
        
        static let rideBookSuccess = "Ride booked successfully"
        static let rideBookSuccessTitle = "You'r ride is successfully booked. ✅"
        static let rideBookSuccessCaption = "Relax, we've sent information about your ride to the ride publisher."
    }
    
    struct UserDefaultKeys {
        static let session = "SessionAuthToken"
        static let profileData = "UserProfileData"
        static let vehiclesData = "VehiclesData"
        static let recentViewedRides = "recentRideSearch"
        static let recentSearches = "recentSearches"
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
        
        static let carpool   = "carpool"
        static let carpoolIcon = "carpoolIcon"
        
        static let defaultImageName = "image.png"
    }
    
    struct DefaultColors {
        static let primary = "#4FB0F4"
    }
    
    // MARK: - default icons
    struct Icon {
        
        static let close            = "xmark"
        static let back             = "chevron.left"
        static let next             = "chevron.right"
        static let check            = "checkmark"
        static let checkCircle      = "checkmark.circle.fill"
        
        static let arrowLeft        = "arrow.forward"
        
        static let edit             = "square.and.pencil"
        static let plusCircle       = "plus.circle"
        static let minusCircle      = "minus.circle"
        
        static let filters          = "slider.horizontal.3"
        
        static let eye              = "eye"
        static let eyeSlash         = "eye.slash"
        
        static let startLocation    = "circle"
        static let endLocation      = "circle"
        
        static let star             = "star.fill"
        
        static let person           = "person"
        static let calendar         = "calendar"
        
        static let car = "car.rear"
        
        static let rupee = "indianrupeesign"
        
        static let enter            = "arrow.up.left"
        
        static let arrowsLeftRight  = "arrow.left.arrow.right"
        
        static let mapMark = "mappin.and.ellipse"
        static let location = "location.fill"
        
        static let history = "clock"
    }
    
    // MARK: - search view
    struct Search {
        
        static let title    = "Where To?"
        static let search   = "Search"
        static let proceed = "Proceed"
        
        static let rideDetails = "Ride Details"
        
        static let searchBarCaption = "%@, %@ Persons"
        
        static let findARide = "Find a ride"
        static let offerARide = "Offer a ride"
        
        static let recentlyViewed = "Recently viewed"
        
        static let route = "Route"
    }
    
    // MARK: - type aliases
    struct TypeAliases {
        //                                  value, placeholde, identifier, keyboard type
        typealias InputFieldArrayType = [(String, String, InputFieldIdentifier, UIKeyboardType)]
    }
    
    // MARK: - rides data
    struct RidesData {
        
        static let info = "%@ | %@ Seats"
        
        static let booked = "Booked"
        static let published = "Published"
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
