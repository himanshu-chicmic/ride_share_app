//
//  ApiConstants.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

struct ApiConstants {
    
    // MARK: - urls
    
    // base url for api
    static let baseURL = "http://192.180.2.134:3001/%@"
    // google places
    static let placesURL = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?fields=formatted_address%2Cgeometry&input="
    static let placesEndpoint = "&inputtype=textquery&key="
    // google maps view
    static let googleMaps = "https://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&mode=driving&key=\(Helpers.fetchAPIKey())"
    
    static let query = "?%@=%@"
    static let addToQuery = "&%@=%@"
    
    static let commonEndpoint = "users"
    
    // MARK: - email
    
    static let getRequestEmailCheck = "?email=%@"
    static let checkEmail = "email_check"
    static let emailConfirmation = "account_activations"
    
    // MARK: - signin
    
    static let signIn = "users/sign_in"
    static let signOut = "users/sign_out"
    
    // MARK: - phone & otp
    
    static let phoneConfirmation = "phone"
    static let otpVerification = "verify"
    
    // MARK: - passwords
    
    static let resetPassword = "users/password"
    
    // MARK: - profile

    static let addImage = "user_images"
    
    // MARK: - vehicles
    
    static let vehicles = "vehicles"
    static let vehicleById = "show_by_id"
    
    // MARK: - rides
    
    static let searchRides = "search"
    static let bookPubilsh = "book_publish"
    static let bookedPublishes = "booked_publishes"
    
    static let publishRide = "publishes"
    static let bookedRides = "booked_publishes"
    static let updateRide = "publishes"
    
    static let cancelBooking = "cancel_booking"
    static let cancelPublished = "cancel_publish"
    
    // MARK: - HTTPHeaderFieldAndValues
    
    struct HTTPHeaderFieldAndValues {
        // values
        static let mutlpartFormData = "multipart/form-data"
        static let applicationJson  = "application/json"
    
        // headers
        static let contentType      = "Content-Type"
        static let authorization    = "Authorization"
    }
    
    // MARK: - StringForDataBody
    
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
