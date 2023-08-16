//
//  Errors.swift
//  CarPool
//
//  Created by Himanshu on 6/3/23.
//

import Foundation

/// enum for handling errors
enum APIErrors: LocalizedError {
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
    
      /// no internet connection available
      case noInternet(String)

      var errorDescription: String? {
        switch self {
        case .invalidRequestError(let message):
          return "Invalid request: \(message)"
        case .transportError(_):
            return "Couldn't connect to server. Please try again later or try restarting application."
        case .invalidResponse:
          return "Unable to get reponse. Check your internet connection."
        case .validationError(let reason):
          return "Validation Error: \(reason)"
        case .decodingError:
          return "Couldn't read data. Try updating the app."
        case .noInternet:
            return "No internet connection available."
        }
      }
}
