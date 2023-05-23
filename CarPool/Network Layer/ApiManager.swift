//
//  ApiManager.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation
import Combine

class ApiManager {
    
    static let shared = ApiManager()
    
    func signInUser(httpMethod: HttpMethod, data: [String: Any], endPoint: String) -> AnyPublisher<GetResponse, Error> {
        
        let baseURL = String(format: ApiConstants.baseURL, endPoint)
        
        guard let url = URL(string: baseURL) else {
            print("error")
            return Fail(error: AuthenticateError.badURL)
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            return Fail(error: AuthenticateError.badURL)
                .eraseToAnyPublisher()
        }
        
        request.httpMethod = httpMethod.rawValue.trimmingCharacters(in: .whitespaces)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // the request is JSON
        request.httpBody = jsonData
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> AuthenticateError in
                print(error.localizedDescription)
                return AuthenticateError.badResponse
            }
        
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                
                guard let response = response as? HTTPURLResponse else {
                    throw AuthenticateError.badConversion
                }
                print(response)
                
                if response.statusCode == 422 {
                    throw AuthenticateError.userExists
                    
                } else if response.statusCode == 401 {
                    throw AuthenticateError.noUserExists
                    
                } else if !((200..<299) ~= response.statusCode) {
                    throw AuthenticateError.badConversion
                }

                return (data, response)
                
            }
            .map(\.data)
        
            .tryMap { data in
                let decoder = JSONDecoder()
                do {
                    return try decoder.decode(GetResponse.self, from: data)
                }
                catch {
                    throw AuthenticateError.badResponse
                }
            }
            .eraseToAnyPublisher()
    }
}

enum AuthenticateError: LocalizedError{
    case badURL
    case badResponse
    case url(URLError?)
    case unknown
    case badConversion
    case noData
    case parsing(DecodingError?)
    case userExists
    case noUserExists
    
    //MARK: custom error description for errors
    var errorDescription: String?{
        switch self{
        case .badConversion:
            return "Cannot convert to json data"
        case .badURL:
            return "URL not found"
        case .badResponse:
            return "Something went wrong, Please check"
        case .url(let error):
            return "\(error?.localizedDescription ?? "")"
        case .unknown:
            return "Sorry, something went wrong."
        case .noData:
            return "No data found"
        case .parsing(let error):
            return "Parsing Error \n\(error?.localizedDescription ?? "")"
        case .userExists:
            return "User Already Exists,\n Log In to continue"
        case .noUserExists:
            return "No Such User Exists,\n Sign Up to continue"
        }
    }
}
