//
//  Errors.swift
//  CarPool
//
//  Created by Nitin on 6/3/23.
//

import Foundation

/// enum for handling errors
enum APIError: LocalizedError {
      /// Invalid request, e.g. invalid URL
      case invalidRequestError(String)
      
      /// Indicates an error on the transport layer, e.g. not being able to connect to the server
      case transportError(Error)
      
      /// Received an invalid response, e.g. non-HTTP result
      case invalidResponse
      
      /// Server-side validation error
      case validationError(String)
      
      /// The server sent data in an unexpected format
      case decodingError(Error)

      var errorDescription: String? {
        switch self {
        case .invalidRequestError(let message):
          return "Invalid request: \(message)"
        case .transportError(let error):
          return "Transport error: \(error)"
        case .invalidResponse:
          return "Invalid response"
        case .validationError(let reason):
          return "Validation Error: \(reason)"
        case .decodingError:
          return "The server returned data in an unexpected format. Try updating the app."
        }
      }
}