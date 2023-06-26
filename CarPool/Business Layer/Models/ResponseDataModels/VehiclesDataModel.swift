//
//  VehiclesDataModel.swift
//  CarPool
//
//  Created by Himanshu on 6/2/23.
//

import Foundation

// MARK: - VehiclesDataModel
struct VehiclesDataModel: Codable {
    let status: VehiclesStatus
}

// MARK: - VehiclesStatus
struct VehiclesStatus: Codable {
    let code: Int
    let message: String?
    let data: [VehiclesDataClass]?
}

// MARK: - VehiclesDataClass
struct VehiclesDataClass: Codable, Hashable {
    
    func getDetailsArray(data: VehiclesDataClass) -> [String] {
        return [
            "\(data.vehicleBrand) | \(data.vehicleName)",
            "\(data.vehicleType) | \(data.vehicleColor) | \(data.vehicleModelYear)",
            data.vehicleNumber
        ]
    }
    
    let userID: Int
    let country, vehicleNumber, vehicleBrand, vehicleName: String
    let vehicleType, vehicleColor: String
    let vehicleModelYear, id: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case country
        case vehicleNumber = "vehicle_number"
        case vehicleBrand = "vehicle_brand"
        case vehicleName = "vehicle_name"
        case vehicleType = "vehicle_type"
        case vehicleColor = "vehicle_color"
        case vehicleModelYear = "vehicle_model_year"
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
