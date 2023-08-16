//
//  RidesSearchModel.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

struct PublishedRidesModel: Codable {
    let code: Int
    let data: [Publish]
}

struct BookedRidesModel: Codable {
    let code: Int
    var rides: [BookedRidesData]
}

struct BookedRidesData: Codable {
    let ride: Publish
    let bookingID, seat: Int
    var status: String
    let reachTime: String?
    var totalPrice: Double

    enum CodingKeys: String, CodingKey {
        case ride
        case bookingID = "booking_id"
        case seat, status
        case reachTime = "reach_time"
        case totalPrice = "total_price"
    }
}

// MARK: - RidesSearchModel
struct RidesSearchModel: Codable {
    let code: Int
    let message: String?
    let data: [Datum]?
    let publish: Publish?
}

// MARK: - Datum
struct Datum: Codable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(UUID())
    }
    
    static func == (lhs: Datum, rhs: Datum) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    let id: Int
    let name: String
    let reachTime: String?
    let imageURL: String?
    let averageRating: Double?
    let aboutRide: String
    let publish: Publish

    enum CodingKeys: String, CodingKey {
        case id, name
        case reachTime = "reach_time"
        case imageURL = "image_url"
        case averageRating = "average_rating"
        case aboutRide = "about_ride"
        case publish
    }
}

// MARK: - Publish
struct Publish: Codable {
    let id: Int
    let source, destination: String
    let passengersCount: Int
    let addCity: String?
    let date, time: String?
    let setPrice: Double
    let aboutRide: String
    let userID: Int
    let createdAt, updatedAt: String
    let sourceLatitude, sourceLongitude, destinationLatitude, destinationLongitude: Double
    let vehicleID: Int?
    let bookInstantly, midSeat: String?
    let selectRoute: SelectRoute?
    let status: String
    let estimateTime: String?
    let addCityLongitude, addCityLatitude: Double?
    let distance: Double?
    let bearing: String?
    
    func getDetailsArray(data: Publish) -> [String] {
        return [
            "Distance (in Kms) \(Formatters.getDistanceInKms(distance: data.distance ?? 0))",
            "\(data.passengersCount) Passengers",
            "Estimated Time (hh:mm) \(Formatters.getEstimatedTime(date: data.estimateTime ?? ""))"
        ]
    }
    
    func getDictData(delegate: SearchViewModel) -> [String: Any] {
        return [
            "id": id,
            "source": delegate.startLocationVal?.formattedAddress ?? source,
            "destination": delegate.endLocationVal?.formattedAddress ?? destination,
            "passengers_count": delegate.numberOfPersons,
            "add_city": addCity,
            "date": Formatters.dateFormatter.string(from: delegate.dateOfDeparture),
            "time": Formatters.timeFormatter.string(from: delegate.dateOfDeparture),
            "set_price": delegate.pricePerSeat,
            "about_ride": aboutRide,
            "user_id": userID,
            "created_at": createdAt,
            "updated_at": updatedAt,
            "source_latitude": delegate.startLocationVal?.geometry.location.lat ?? sourceLatitude,
            "source_longitude": delegate.startLocationVal?.geometry.location.lng ?? sourceLongitude,
            "destination_latitude": delegate.endLocationVal?.geometry.location.lat ?? destinationLatitude,
            "destination_longitude": delegate.endLocationVal?.geometry.location.lng ?? destinationLongitude,
            "vehicle_id": delegate.selectedVehicleId == 0 ? vehicleID : delegate.selectedVehicleId,
            "book_instantly": bookInstantly,
            "mid_seat": midSeat,
            "select_route": selectRoute,
            "status": status,
            "estimate_time": delegate.estimatedTime,
            "addCity_longitude": addCityLongitude,
            "addCity_latitude": addCityLatitude,
            "distance": distance,
            "bearing": bearing
        ]
    }

    enum CodingKeys: String, CodingKey {
        case id, source, destination
        case passengersCount = "passengers_count"
        case addCity = "add_city"
        case date, time
        case setPrice = "set_price"
        case aboutRide = "about_ride"
        case userID = "user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case sourceLatitude = "source_latitude"
        case sourceLongitude = "source_longitude"
        case destinationLatitude = "destination_latitude"
        case destinationLongitude = "destination_longitude"
        case vehicleID = "vehicle_id"
        case bookInstantly = "book_instantly"
        case midSeat = "mid_seat"
        case selectRoute = "select_route"
        case status
        case estimateTime = "estimate_time"
        case addCityLongitude = "add_city_longitude"
        case addCityLatitude = "add_city_latitude"
        case distance, bearing
    }
}

// MARK: - SelectRoute
struct SelectRoute: Codable {
    let routes: [Route]?
}

// MARK: - Route
struct Route: Codable {
    let legs: [Leg]
    let overviewPolyline: OverviewPolyline

    enum CodingKeys: String, CodingKey {
        case legs
        case overviewPolyline = "overview_polyline"
    }
}

// MARK: - Leg
struct Leg: Codable {
    let distance, duration: Distance
}

// MARK: - Distance
struct Distance: Codable {
    let value: Int
    let text: String
}

// MARK: - OverviewPolyline
struct OverviewPolyline: Codable {
    let points: String
}
