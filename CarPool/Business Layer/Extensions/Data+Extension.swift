//
//  File.swift
//  CarPool
//
//  Created by Himanshu on 5/31/23.
//

import Foundation

/// extension for Data
/// containg append method
/// used in appending the data from string to .utf8 format
extension Data {
    
    /// method to append string value to data
    /// - Parameter string: a string value containing some data
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
