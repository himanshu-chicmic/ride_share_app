//
//  PlacesDataModel.swift
//  CarPool
//
//  Created by Nitin on 6/2/23.
//

import Foundation

// MARK: - PlacesDataModel
struct PlacesDataModel: Codable {
    let candidates: [Candidate]
    let status: String
}

// MARK: - Candidate
struct Candidate: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(UUID())
    }
    
    static func == (lhs: Candidate, rhs: Candidate) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    let formattedAddress: String
    let geometry: Geometry

    enum CodingKeys: String, CodingKey {
        case formattedAddress = "formatted_address"
        case geometry
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: Location
    let viewport: Viewport
}

// MARK: - Location
struct Location: Codable {
    let lat, lng: Double
}

// MARK: - Viewport
struct Viewport: Codable {
    let northeast, southwest: Location
}
