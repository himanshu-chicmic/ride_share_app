//
//  ApiManager.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation
import Combine

/// api manager class for handling api calls and responses
class ApiManager {
    
    // static shared instance of api manageer class
    static let shared = ApiManager()
    
    /// method to set up api request and return it as url request
    /// - Parameters:
    ///   - endPoint: string value of api endpoint. used with base api url to form a valid url
    ///   - httpMethod: method of api request i.e. get, post, delete, put
    ///   - data: dictionary for sending some json data alog with api
    ///   - requestType: type of request i.e. signup, login, email check etc.
    /// - Returns: a url request which is used to for url session
    func setUpApiRequest(httpMethod: HttpMethod, data: [String: Any], requestType: RequestType) -> URLRequest? {
        
        // create a base url
        var baseURL = String(format: ApiConstants.baseURL, requestType.rawValue)
        
        // if request typ if of type email check
        // then our url need to be changed
        // to handle the get request
        // in get request the data needs to be sent
        // with the url
        if requestType == .emailCheck, let email = data[InputFieldIdentifier.email.rawValue] as? String {
            baseURL += String(format: ApiConstants.getRequestEmailCheck, email.lowercased())
        }
        
        // get the url from base url string
        guard let url = URL(string: baseURL) else {
            // return nil if url is invalid
            return nil
        }
        
        // initialize url request
        var request = URLRequest(url: url)
        
        // set the http method
        request.httpMethod = httpMethod.rawValue.trimmingCharacters(in: .whitespaces)
        
        // if request is of type logout
        if requestType == .logOut {
            // set the token value to request headers by fetching
            // it from user defaults
            if let tokenValue = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.session) {
                request.setValue(tokenValue, forHTTPHeaderField: ApiConstants.authorization)
            }
        }
        // for request type signup and login
        else if requestType == .signUp || requestType == .logIn {
            // convert dictionary data to json
            let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
            // set content type
            request.setValue(ApiConstants.json, forHTTPHeaderField: ApiConstants.contentType)
            // set json data in request http body
            request.httpBody = jsonData
        }
        
        // return url request
        return request
    }
    
    /// method to handle signin, login, create user, logout and get user details
    /// - Parameters:
    ///   - httpMethod: method of api request i.e. get, post, delete, put
    ///   - dataDictionary: dictionary for sending some json data alog with api
    ///   - endPoint: string value of api endpoint. used with base api url to form a valid url
    ///   - requestType: type of request i.e. signup, login, email check etc.
    /// - Returns: any published with either response as SignInLogInModel or Error
    func createApiRequest(httpMethod: HttpMethod, dataDictionary: [String: Any], requestType: RequestType) -> AnyPublisher<SignInAndProfileModel, Error> {
        
        // get url request from setUpApiRequest method
        guard let request = setUpApiRequest(
            httpMethod  : httpMethod,
            data        : dataDictionary,
            requestType : requestType
        ) else {
            // return error if request is nil
            return Fail(error: APIError.invalidRequestError("URL Invalid"))
                .eraseToAnyPublisher()
        }
        
        // use dataTaskPublisher to call the api for url request
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapping error related to invalid format or key values or data limitations
            .mapError { error -> Error in
                return APIError.transportError(error)
            }
            // map data and reponse and return
            // after getting response as HTTPURLResponse
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                
                // get reponse as HTTPURLResponse
                guard let response = response as? HTTPURLResponse else {
                    // else throw error as invalid response
                    throw APIError.invalidResponse
                }
                
                // if sign out it attempted
                // the clear the user defaults
                // by setting the authoriztion value of
                // SessionAuthToken to empty ""
                if requestType == .logOut {
                    UserDefaults.standard.set("", forKey: Constants.UserDefaultKeys.session)
                }
                // else get the bearer token from the reponse and
                // set the user default for SessionAuthToken
                else if requestType == .signUp || requestType == .logIn {
                    // get token from response header
                    let bearer = response.value(forHTTPHeaderField: ApiConstants.authorization)
                    if let bearer {
                        // store in user defaults
                        UserDefaults.standard.set(bearer, forKey: Constants.UserDefaultKeys.session)
                    }
                }
                
                // return data and response
                return (data, response)
            }
            // mapping data
            .map(\.data)
            // decoding data
            .tryMap { data in
                // initialize json decoder
                let decoder = JSONDecoder()
                do {
                    // if request type is of email check
                    // do not decode with SignInLogInModel directly
                    // set it up manually
                    // to avoid decoding error on. we need to avoid it
                    // because the api returns success with empty body
                    // which cannot be decoded thus check with data.count
                    // which gives the value of data
                    switch requestType {
                    case .emailCheck:
                        // set the status instance
                        let status = Status(code: data.count, error: nil, message: nil, data: nil, imageURL: nil)
                        // return signinlogin model with status instance
                        return SignInAndProfileModel(status: status)
                    default:
                        UserDefaults.standard.set(data, forKey: Constants.UserDefaultKeys.profileData)
                    }
                    return try decoder.decode(SignInAndProfileModel.self, from: data)
                } catch {
                    throw APIError.decodingError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

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
