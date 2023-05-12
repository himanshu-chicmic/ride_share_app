//
//  TabViewIdentifier.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import Foundation

/// tab views identifier enums
enum TabViewIdentifier: RawRepresentable {
    case search
    case rides
    case inbox
    case profile
    
    /// get raw values based on current
    /// value of the enum
    var rawValue: (text: String, image: String) {
        switch self {
            case .search    : return (text: "Search", image: "magnifyingglass")
            case .rides     : return (text: "Your Rides", image: "quote.opening")
            case .inbox     : return (text: "Inbox", image: "message")
            case .profile   : return (text: "Profile", image: "person.crop.circle")
        }
    }
    
    /// parameterized initializer
    /// - Parameter rawValue: value containing tuple of (String, String)
    init?(rawValue: (text: String, image: String)) {
        switch rawValue {
            case ("Search", "magnifyingglass")      : self = .search
            case ("Your Rides", "quote.opening")    : self = .rides
            case ("Inbox", "message")               : self = .inbox
            case ("Profile", "person.crop.circle")  : self = .profile
            default: return nil
        }
    }
}
