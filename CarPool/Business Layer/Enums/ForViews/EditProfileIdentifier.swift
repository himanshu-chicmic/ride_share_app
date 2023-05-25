//
//  EditProfileViewIdentifier.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI

/// enum for opening different view
/// when editing profile
enum EditProfileIdentifier: String, Identifiable {
    
    // id for identifiable confirmation
    var id: Self {
        self
    }
    
    // cases for edit profile type
    case email    = "Confirm email %@"
    case mobile   = "Confirm phone number"
    case bio      = "Add a mini bio"
    case vehicles = "Add vehicle"
    
    // get view based on the cases
    @ViewBuilder var view: some View {
        switch self {
        case .email:
            AddProfileOptionView(
                heading      : Constants.Headings.email,
                placeholder  : Constants.Placeholders.email,
                inputField   : .email,
                keyboardType : .emailAddress
            )
        case .mobile:
            AddProfileOptionView(
                heading      : Constants.Headings.mobile,
                placeholder  : Constants.Placeholders.mobile,
                inputField   : .phoneNumber,
                keyboardType : .numberPad
            )
        case .bio:
            AddProfileOptionView(
                heading      : Constants.Headings.bio,
                placeholder  : Constants.Placeholders.bio,
                inputField   : .bio,
                keyboardType : .default
            )
        case .vehicles:
            AddProfileOptionView(
                heading      : Constants.Headings.vehicle,
                placeholder  : "",
                inputField   : .country,
                keyboardType : .default
            )
        }
    }
}
