//
//  ApiConstants.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

struct ApiConstants {
    
    // base url for api
    static let baseURL = "https://6114-112-196-113-2.ngrok-free.app/%@"
    static let placesURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cgeometry&input="
    static let placesEndpoint = "&inputtype=textquery&key="
    
    static let getRequestEmailCheck = "?email=%@"
    static let query = "?%@=%@"
    static let addToQuery = "&%@=%@"
    
    // this endpoint is used for following type of request
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
    
    // MARK: vehicles
    // get or add vehicles
    static let vehicles = "vehicles"
    
    static let vehicleById = "show_by_id"
    
    // used to send two api requests
    // one for sending email and generating
    // a token for reset password
    // second for sending new password with
    // the token to change password
    static let resetPassword = "users/password"
    
    static let searchRides = "search"
    
    static let bookPubilsh = "book_publish"
    
    static let bookedPublishes = "booked_publishes"
    
    // add image to user profile
    static let addImage = "user_images"
    
    static let authorization = "Authorization"
    static let contentType = "Content-Type"
    static let json = "application/json"
    
    // MARK: - https header fields and values
    struct HTTPHeaderFieldAndValues {
        // values
        static let mutlpartFormData = "multipart/form-data"
        static let applicationJson  = "application/json"
    
        // headers
        static let contentType      = "Content-Type"
        static let authorization    = "Authorization"
    }
    
    // MARK: - string format
    struct StringForDataBody {
        
        static let lineBreak                        = "\r\n"
        static let boundary                         = UUID().uuidString
        
        static let multipartFormData                = "\(HTTPHeaderFieldAndValues.mutlpartFormData); boundary=\(boundary)"
        
        static let imageMimePng                    = "image/png"
        
        static let imageContentType                 = "Content-Type: %@\(lineBreak + lineBreak)"
        
        static let imageContentDisposition          = "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\(lineBreak)"
        static let dataContentDisposition           = "Content-Disposition: form-data; name=\"%@\"\(lineBreak + lineBreak)"
        
        static let boudaryWithLineBreakTwoHyphens   = "--\(boundary + lineBreak)"
        static let boudaryWithLineBreakFourHyphens  = "--\(boundary)--\(lineBreak)"
    }
}
