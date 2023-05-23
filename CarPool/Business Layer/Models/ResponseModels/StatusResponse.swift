//
//  SignOutResponse.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation

//struct StatusResponse {
//    let status: Int
//    let message: String
//}

// MARK: - GetResponse
struct GetResponse: Codable {
    let status: GetStatus
}

// MARK: - Status
struct GetStatus: Codable {
    let code: Int
    let error: String
}
