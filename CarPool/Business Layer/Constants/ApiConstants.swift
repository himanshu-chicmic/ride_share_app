//
//  ApiConstants.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

struct ApiConstants {
    
    // base url for api
    static let baseURL = "https://940e-112-196-113-2.ngrok-free.app/%@"
    
    static let getRequestEmailCheck = "?email=%@"
    
    // this endpoint is used for following type of reques
    // Post - to sign up
    // Delete - for account deletion
    // Get - to get information of current user
    // Put - to update information of user
    static let commonEndpoint = "users"
    
    // check if email exists on signup
    static let checkEmail = "email_check"
    
    // sign in existing user
    static let signIn = "users/sign_in"
    
    // sign out current user
    static let signOut = "users/sign_out"
    
    // email confirmation
    static let emailConfirmation = "account_activations"
    
    // phone number verfication
    static let phoneConfirmation = "phone"
    // otp verification
    static let otpVerification = "verify"
    
    // used to send two api requests
    // one for sending email and gerating
    // a token for reset password
    // second for sending new password with
    // the token to change password
    static let resetPassword = "users/password"
    
    // add image to user profile
    static let addImage = "user_images"
    
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let json = "application/json"
    
}
