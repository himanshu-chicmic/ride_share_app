//
//  InputFieldIdentifier.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import Foundation

/// contains cases to identify
/// the type of input field
enum InputFieldIdentifier: String {
    case email
    case password
    case confirmPassword
    case firstName       = "first_name"
    case lastName        = "last_name"
    case dateOfBirth     = "dob"
    case gender          = "title"
    case phoneNumber     = "phone_number"
    case country
    case color
    case model
    case text
    case bio
    case passcode
}
