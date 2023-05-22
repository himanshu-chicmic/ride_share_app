//
//  UserInformationResponse.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

// MARK: - UserInformationResponse
struct UserInformationResponse: Codable {
    let status: InfoStatus
}

// MARK: - InfoStatus
struct InfoStatus: Codable {
    let code: Int
    let data: InfoDataClass
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case code, data
        case imageURL = "image_url"
    }
}

// MARK: - InfoDataClass
struct InfoDataClass: Codable {
    let id: Int
    let email, createdAt, updatedAt, jti: String
    let firstName, lastName, dob, title: String
    let phoneNumber, bio, travelPreferences, postalAddress: String?
    let activationDigest: String
    let activated, activatedAt: String?
    let activateToken: String
    let sessionKey, averageRating: String?

    enum CodingKeys: String, CodingKey {
        case id, email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case jti
        case firstName = "first_name"
        case lastName = "last_name"
        case dob, title
        case phoneNumber = "phone_number"
        case bio
        case travelPreferences = "travel_preferences"
        case postalAddress = "postal_address"
        case activationDigest = "activation_digest"
        case activated
        case activatedAt = "activated_at"
        case activateToken = "activate_token"
        case sessionKey = "session_key"
        case averageRating = "average_rating"
    }
}
