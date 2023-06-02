//
//  SignInAndProfileModel.swift
//  CarPool
//
//  Created by Himanshu on 5/24/23.
//

import Foundation

// MARK: - SignInAndProfileModel
struct SignInAndProfileModel: Codable {
    let status: Status
}

// MARK: - Status
struct Status: Codable {
    var code: Int
    let error: String?
    let errors: [String]?
    var message: String?
    let data: DataClass?
    let imageURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case code, error, message, data
        case errors
        case imageURL = "image_url"
    }
}

// MARK: - DataClass
struct DataClass: Codable {
    let id: Int
    let email, createdAt, updatedAt, jti: String
    let firstName, lastName, dob, title: String
    let phoneNumber, bio, travelPreferences, postalAddress: String?
    let activationDigest: String
    let activated: Bool?
    let activatedAt: String?
    let activateToken: String
    let sessionKey: String?
    let phoneVerified: Bool?
    let averageRating: String?
    let customToken: String?
    let otp: Int? = 0

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt         = "created_at"
        case updatedAt         = "updated_at"
        case jti
        case firstName         = "first_name"
        case lastName          = "last_name"
        case dob, title
        case phoneNumber       = "phone_number"
        case bio
        case travelPreferences = "travel_preferences"
        case postalAddress     = "postal_address"
        case activationDigest  = "activation_digest"
        case activated
        case activatedAt       = "activated_at"
        case activateToken     = "activate_token"
        case sessionKey        = "session_key"
        case phoneVerified      = "phone_verified"
        case averageRating     = "average_rating"
        case customToken       = "custom_token"
        case otp          
    }
}
