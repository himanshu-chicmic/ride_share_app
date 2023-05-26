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
    case signUp
    case emailCheck
    case logIn
    case logOut
    case getDetails
    case updateProfile
    case confirmEmail
    case confirmPhone
    case confirmOtp
    case forgotPassword
    case resetPassword
    
    /// get raw values based on current
    /// value of the enum
    var rawValue: String {
        switch self {
        case .signUp, .getDetails, .updateProfile:
            return ApiConstants.commonEndpoint
        case .emailCheck:
            return ApiConstants.checkEmail
        case .logIn:
            return ApiConstants.signIn
        case .logOut:
            return ApiConstants.signOut
        case .confirmEmail:
            return ApiConstants.emailConfirmation
        case .confirmPhone:
            return ApiConstants.phoneConfirmation
        case .confirmOtp:
            return ApiConstants.otpVerification
        case .forgotPassword, .resetPassword:
            return ApiConstants.resetPassword
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
        case ApiConstants.checkEmail:
            self = .emailCheck
        case ApiConstants.signIn:
            self = .logIn
        case ApiConstants.signOut:
            self = .logOut
        case ApiConstants.emailConfirmation:
            self = .confirmEmail
        case ApiConstants.phoneConfirmation:
            self = .confirmPhone
        case ApiConstants.otpVerification:
            self = .confirmOtp
        case ApiConstants.resetPassword:
            self = .forgotPassword
            self = .resetPassword
        default:
            return nil
        }
    }
}