//
//  RequestType.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

/// enum for checking for what kind of
/// api request is sent
enum RequestType: RawRepresentable {
    
    // MARK: - signin
    case signUp
    case emailCheck
    case logIn
    case logOut
    case deleteAccount
    
    // MARK: - password
    case sendOtpEmail
    case emailOtpVerify
    case resetPassword
    
    // MARK: - activations
    case confirmEmail
    case confirmPhone
    case confirmOtp
    
    // MARK: - details
    case getDetails
    case updateProfile
    case uploadImage
    
    // MARK: - vehicles
    case vehicles
    case getVehicles
    case updateVehicle
    case deleteVehicle
    case getVehicleById
    
    // MARK: - rides
    case searchRides
    case updateRide
    
    case bookPublish
    case bookedPublishes
    case bookedRides
    
    case publishedRides
    case publishedRideById
    
    case cancelBooking
    case cancelPublished
    
    // MARK: - messaging
    case chatRooms
    case chatMessages
    
    /// get raw values based on current
    /// value of the enum
    var rawValue: String {
        switch self {
        case .sendOtpEmail:
            return ApiConstants.sendOtpEmail
        case .emailOtpVerify:
            return ApiConstants.emailOtpVerify
        case .resetPassword:
            return ApiConstants.resetPassword
        case .signUp, .getDetails, .updateProfile, .deleteAccount:
            return ApiConstants.commonEndpoint
        case .emailCheck:
            return ApiConstants.checkEmail
        case .uploadImage:
            return ApiConstants.addImage
        case .logIn:
            return ApiConstants.signIn
        case .logOut:
            return ApiConstants.signOut
        case .confirmEmail:
            return ApiConstants.emailActivation
        case .confirmPhone:
            return ApiConstants.phoneConfirmation
        case .confirmOtp:
            return ApiConstants.otpVerification
        case .vehicles, .getVehicles, .updateVehicle, .deleteVehicle:
            return ApiConstants.vehicles
        case .getVehicleById:
            return ApiConstants.vehicleById
        case .searchRides:
            return ApiConstants.searchRides
        case .bookPublish:
            return ApiConstants.bookPubilsh
        case .bookedPublishes:
            return ApiConstants.bookedPublishes
        case .publishedRides, .publishedRideById:
            return ApiConstants.publishRide
        case .bookedRides:
            return ApiConstants.bookedRides
        case .updateRide:
            return ApiConstants.updateRide
        case .cancelBooking:
            return ApiConstants.cancelBooking
        case .cancelPublished:
            return ApiConstants.cancelPublished
        case .chatRooms:
            return ApiConstants.chatRoom
        case .chatMessages:
            return ApiConstants.chatMessages
        }
    }
    
    /// parameterized initializer
    /// - Parameter rawValue: value containing a string
    init?(rawValue: String) {
        switch rawValue {
        case ApiConstants.commonEndpoint:
            self = .signUp
            self = .getDetails
            self = .updateProfile
            self = .deleteAccount
        case ApiConstants.checkEmail:
            self = .emailCheck
        case ApiConstants.signIn:
            self = .logIn
        case ApiConstants.signOut:
            self = .logOut
        case ApiConstants.emailActivation:
            self = .confirmEmail
        case ApiConstants.phoneConfirmation:
            self = .confirmPhone
        case ApiConstants.otpVerification:
            self = .confirmOtp
        case ApiConstants.vehicles:
            self = .vehicles
            self = .getVehicles
            self = .updateVehicle
            self = .deleteVehicle
        case ApiConstants.searchRides:
            self = .searchRides
        case ApiConstants.vehicleById:
            self = .getVehicleById
        case ApiConstants.bookPubilsh:
            self = .bookPublish
        case ApiConstants.bookedPublishes:
            self = .bookedPublishes
        case ApiConstants.publishRide:
            self = .publishedRides
        case ApiConstants.bookedRides:
            self = .bookedRides
        case ApiConstants.updateRide:
            self = .updateRide
        case ApiConstants.cancelBooking:
            self = .cancelBooking
        case ApiConstants.cancelPublished:
            self = .cancelPublished
        case ApiConstants.chatRoom:
            self = .chatRooms
        case ApiConstants.chatMessages:
            self = .chatMessages
        case ApiConstants.resetPassword:
            self = .resetPassword
        case ApiConstants.emailOtpVerify:
            self = .emailOtpVerify
        case ApiConstants.sendOtpEmail:
            self = .sendOtpEmail
        default:
            return nil
        }
    }
}
