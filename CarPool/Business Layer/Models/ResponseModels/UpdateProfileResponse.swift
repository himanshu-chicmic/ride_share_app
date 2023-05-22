//
//  UpdateProfileResponse.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

// MARK: - UpdateProfileResponse
struct UpdateProfileResponse: Codable {
    let status: UpdateStatus
}

// MARK: - UpdateStatus
struct UpdateStatus: Codable {
    let code: Int
    let message: String
    let data: UpdateDataClass
}

// MARK: - UpdateDataClass
struct UpdateDataClass: Codable {
    let email, firstName, lastName, bio: String
    let postalAddress, title, dob, travelPreferences: String
    let phoneNumber: String
    let id: Int
    let createdAt, updatedAt, jti, activationDigest: String
    let activated, activatedAt: String?
    let activateToken: String
    let sessionKey, averageRating: String?

    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case bio
        case postalAddress = "postal_address"
        case title, dob
        case travelPreferences = "travel_preferences"
        case phoneNumber = "phone_number"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case jti
        case activationDigest = "activation_digest"
        case activated
        case activatedAt = "activated_at"
        case activateToken = "activate_token"
        case sessionKey = "session_key"
        case averageRating = "average_rating"
    }
}
