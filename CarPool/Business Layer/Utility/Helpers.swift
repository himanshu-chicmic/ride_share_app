//
//  Helpers.swift
//  CarPool
//
//  Created by Himanshu on 8/9/23.
//

import Foundation
import SwiftUI
import Combine

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
            return status
        } else if status == "cancelled_by_driver" {
            return "cancel by driver"
        } else if status == "pending" {
            return "active"
        } else if status == "cancel booking" {
            return "cancelled"
        } else if status == "confirm booking" {
            return "confirmed"
        }
        
        return status
    }
    
    /// method to handle completion for api call result.
    /// - Parameter completion: completion from api
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .failure(let error):
            print("ERROR: \(error)")
            BaseViewModel.shared.toastMessageBackground = .red
            BaseViewModel.shared.toastMessage = error.localizedDescription
        case .finished:
            print("success")
        }
        BaseViewModel.shared.inProgess = false
    }
    
    /// method to check if email or phone number are activated or verified
    /// - Parameter inputField: type of input field
    /// - Returns: bool value (true if verified else false)
    static func disableTextFieldIfActivated(inputField: InputFieldIdentifier) -> Bool {
        let userData = BaseViewModel.shared.userData?.status.data
        if let activation = userData?.activated {
            if inputField == .email && activation {
                return true
            }
        }
        
        if let activation = userData?.phoneVerified {
            if inputField == .phoneNumber && activation {
                return true
            }
        }
        
        return false
    }
    

}
