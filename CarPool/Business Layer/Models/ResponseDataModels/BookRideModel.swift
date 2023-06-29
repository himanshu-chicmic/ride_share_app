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
    let id, userID, publishID: Int
    let createdAt, updatedAt: String
    let price, seats: Int
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case publishID = "publish_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case price, seats, status
    }
}
