//
//  RideBookAndPublishModel.swift
//  CarPool
//
//  Created by Himanshu on 6/14/23.
//

import Foundation

// MARK: - BookRideModel
struct BookRideModel: Codable {
    let code: Int
    let passenger: Passenger?
    let error: String?
}

// MARK: - Passenger
struct Passenger: Codable {
    
    let firstName, lastName, dob, phoneNumber: String?
    let phoneVerified: Bool?
    let image: String?
    let averageRating: String?
    let bio: String?
    let travelPreferences: String?
    
    let id, publishID: Int?
    let userID: Int
    let createdAt, updatedAt: String?
    let price, seats: Int?
    let status: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case dob
        case phoneNumber = "phone_number"
        case phoneVerified = "phone_verified"
        case image
        case averageRating = "average_rating"
        case bio
        case travelPreferences = "travel_preferences"
        case price, seats, status
        case publishID = "publish_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
