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
    let code: Int
    let error: String?
    let errors: [String]?
    let message: String?
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
    let activated: String?
    let activatedAt: String?
    let activateToken: String
    let sessionKey: String?
    let averageRating: String?

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
        case averageRating     = "average_rating"
    }
}