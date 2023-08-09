//
//  Helpers.swift
//  CarPool
//
//  Created by Himanshu on 8/9/23.
//

import Foundation
import SwiftUI

/// struct containing common helper methods
struct Helpers {
    
    /// method to fetch api key from project
    /// - Returns: api key as string
    static func fetchAPIKey() -> String {
        if let apikey = Bundle.main.infoDictionary?[Constants.JsonKeys.places] as? String {
            return apikey
        }
        return ""
    }
    
    /// method to return color based on status of ride
    /// - Parameter rideStatus: string value of ride status
    /// - Returns: color
    static func returnStatusColor(rideStatus: String) -> Color {
        switch rideStatus {
        case RideStatus.completed.rawValue, RideStatus.confirmed.rawValue:
            return .green
        case RideStatus.active.rawValue:
            return .yellow
        default:
            return .red
        }
    }
    
    /// method to return ride status
    /// - Parameter status: string value of ride status
    /// - Returns: string
    static func getRideStatus(status: String) -> String {
        if status == "cancelled" {
            return "cancel"
        } else if status == "pending" {
            return "active"
        } else if status == "cancel booking" {
            return "cancelled"
        } else if status == "confirm booking" {
            return "confirmed"
        }
        
        return status
    }
}
