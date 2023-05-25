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
        case .search  : return (text: Constants.TabView.search, image: Constants.TabView.searchIcon)
        case .rides   : return (text: Constants.TabView.rides, image: Constants.TabView.ridesIcon)
        case .inbox   : return (text: Constants.TabView.inbox, image: Constants.TabView.inboxIcon)
        case .profile : return (text: Constants.TabView.profile, image: Constants.TabView.profileIcon)
        }
    }
    
    /// parameterized initializer
    /// - Parameter rawValue: value containing tuple of (String, String)
    init?(rawValue: (text: String, image: String)) {
        switch rawValue {
        case (text: Constants.TabView.search, image: Constants.TabView.searchIcon)   : self = .search
        case (text: Constants.TabView.rides, image: Constants.TabView.ridesIcon)     : self = .rides
        case (text: Constants.TabView.inbox, image: Constants.TabView.inboxIcon)     : self = .inbox
        case (text: Constants.TabView.profile, image: Constants.TabView.profileIcon) : self = .profile
        default                                                                      : return nil
        }
    }
}
