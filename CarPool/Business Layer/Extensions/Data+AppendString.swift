//
//  Data+AppendString.swift
//  CarPool
//
//  Created by Himanshu on 5/31/23.
//

import Foundation

extension Data {
    
    /// method to append string value to data
    /// - Parameter string: a string value containing some data
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
