//
//  ApiManager.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
//

import Foundation
import Combine
import Network

/// api manager class for handling api calls and responses
class ApiManager {
    
    // MARK: - properties
    
    // static shared instance of api manageer class
    static let shared = ApiManager()
    
    // MARK: - methods
    
    // MARK: methods to create and send api requests
    /// method to handle signin, login, create user, logout and get user details
    /// - Parameters:
    ///   - httpMethod: method of api request i.e. get, post, delete, put
    ///   - dataDictionary: dictionary for sending some json data alog with api
    ///   - endPoint: string value of api endpoint. used with base api url to form a valid url
    ///   - requestType: type of request i.e. signup, login, email check etc.
    /// - Returns: any published with either response as SignInLogInModel or Error
    func createApiRequest(
        httpMethod: HttpMethod, dataDictionary: [String: Any], requestType: RequestType
    ) -> AnyPublisher<SignInAndProfileModel, Error> {
        
        NetworkMonitor.shared.startMonitoring()
        if NetworkMonitor.shared.isReachable {
            NetworkMonitor.shared.stopMonitoring()
            return Fail(error: APIErrors.noInternet(Constants.ErrorsMessages.noInternetConnection))
                .eraseToAnyPublisher()
        }
        NetworkMonitor.shared.stopMonitoring()
        
        // get url request from setUpApiRequest method
        guard let request = setUpApiRequest(
            httpMethod  : httpMethod,
            data        : dataDictionary,
            requestType : requestType
        ) else {
            // return error if request is nil
            return Fail(
                error: APIErrors.invalidRequestError(Constants.ErrorsMessages.invalidUrl)
            ).eraseToAnyPublisher()
        }
        
        // use dataTaskPublisher to call the api for url request
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapping error related to invalid format or key values or data limitations
            .mapError { error -> Error in
                return APIErrors.transportError(error)
            }
            // map data and reponse and return
            // after getting response as HTTPURLResponse
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                // call getHttpURLResponse to return (data, response)
                // or throw any error if found
                return try self.getHttpURLResponse(
                    requestType : requestType,
                    response    : response,
                    data        : data
                )
            }
            .map(\.data)
            .tryMap { data in
                do {
                    // call method to decode data and get response in SignInProfileModel type
                    return try self.decodeSignInRequestData(
                        requestType : requestType,
                        data        : data
                    )
                }
                // if control entered in catch block, means there's a decoding error.
                // in this api mutliple api request are handled and data returned are not always of same structure
                // handling of this is done by json serialization and setting data using keys returned in json response
                // by dedoding data in a dictionary format
                catch {
                    return try self.decodeSignInRequestAdditionalData(
                        requestType : requestType,
                        data        : data,
                        error       : error
                    )
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// method to add, get or delete vehicles
    /// - Parameters:
    ///   - httpMethod: method of api request i.e. get, post, delete, put
    ///   - dataDictionary: dictionary for sending some json data alog with api
    ///   - endPoint: string value of api endpoint. used with base api url to form a valid url
    ///   - requestType: type of request i.e. signup, login, email check etc.
    /// - Returns: any published with either response as VehiclesDataModel or Error
    func createVehiclesApiRequest(
        httpMethod: HttpMethod, dataDictionary: [String: Any], requestType: RequestType
    ) -> AnyPublisher<VehiclesDataModel, Error> {
        
        NetworkMonitor.shared.startMonitoring()
        if NetworkMonitor.shared.isReachable {
            NetworkMonitor.shared.stopMonitoring()
            return Fail(error: APIErrors.noInternet(Constants.ErrorsMessages.noInternetConnection))
                .eraseToAnyPublisher()
        }
        NetworkMonitor.shared.stopMonitoring()
        
        // get url request from setUpApiRequest method
        guard let request = setUpApiRequest(
            httpMethod  : httpMethod,
            data        : dataDictionary,
            requestType : requestType
        ) else {
            // return error if request is nil
            return Fail(error: APIErrors.invalidRequestError(Constants.ErrorsMessages.invalidUrl))
                .eraseToAnyPublisher()
        }
        
        // use dataTaskPublisher to call the api for url request
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapping error related to invalid format or key values or data limitations
            .mapError { error -> Error in
                return APIErrors.transportError(error)
            }
            // map data and reponse and return
            // after getting response as HTTPURLResponse
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                return try self.getHttpURLResponse(
                    requestType : requestType,
                    response    : response,
                    data        : data
                )
            }
            // mapping data
            .map(\.data)
            // decoding data
            .tryMap { data in
                do {
                    // call decodeVehiclesRequestData method to decode data and return response
                    // or otherwise throw any error
                    return try self.decodeVehiclesRequestData(
                        httpMethod  : httpMethod,
                        data        : data,
                        requestType : requestType
                    )
                } catch {
                    // thrown decoding error message
                    throw APIErrors.decodingError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// method to get places data from using google places api
    /// - Parameters:
    ///   - httpMethod: method type of request
    ///   - text: text description of place
    ///   - requestType: type of request
    /// - Returns: any published with either response as PlacesDataModel or Error
    func getPlacesData(httpMethod: HttpMethod, text: String, requestType: RequestType) -> AnyPublisher<PlacesDataModel, Error> {
        
        NetworkMonitor.shared.startMonitoring()
        if NetworkMonitor.shared.isReachable {
            NetworkMonitor.shared.stopMonitoring()
            return Fail(error: APIErrors.noInternet(Constants.ErrorsMessages.noInternetConnection))
                .eraseToAnyPublisher()
        }
        NetworkMonitor.shared.stopMonitoring()
        
        // create a base url
        let baseURL = ApiConstants.placesURL + Globals.getTextQueryWithReplacedCharsWithPlus(text: text) + ApiConstants.placesEndpoint + Globals.fetchAPIKey()
        // get the url from base url string
        guard let url = URL(string: baseURL) else {
            // return nil if url is invalid
            return Fail(error: APIErrors.invalidRequestError(Constants.ErrorsMessages.invalidUrl))
                .eraseToAnyPublisher()
        }
        // initialize url request
        var request = URLRequest(url: url)
        // set the http method
        request.httpMethod = httpMethod.rawValue.trimmingCharacters(in: .whitespaces)
        
        // use dataTaskPublisher to call the api for url request
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapping error related to invalid format or key values or data limitations
            .mapError { error -> Error in
                return APIErrors.transportError(error)
            }
            // map data and reponse and return
            // after getting response as HTTPURLResponse
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                // get httpurl response
                return try self.getHttpURLResponse(
                    requestType : requestType,
                    response    : response,
                    data        : data
                )
            }
            .map(\.data)
            .tryMap { data in
                do {
                    return try JSONDecoder().decode(PlacesDataModel.self, from: data)
                } catch {
                    throw APIErrors.decodingError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// method to get search results for ride search
    /// - Parameters:
    ///   - httpMethod: method for api request
    ///   - data: data that needs to be sent with api
    ///   - requestType: type of api request
    /// - Returns: any published with either response as PlacesDataModel or Error
    func getSearchResults(httpMethod: HttpMethod, data: [String: Any], requestType: RequestType) -> AnyPublisher<RidesSearchModel, Error> {
        
        NetworkMonitor.shared.startMonitoring()
        if NetworkMonitor.shared.isReachable {
            NetworkMonitor.shared.stopMonitoring()
            return Fail(error: APIErrors.noInternet(Constants.ErrorsMessages.noInternetConnection))
                .eraseToAnyPublisher()
        }
        NetworkMonitor.shared.stopMonitoring()
        
        // get url request from setUpApiRequest method
        guard let request = setUpApiRequest(
            httpMethod  : httpMethod,
            data        : data,
            requestType : requestType
        ) else {
            // return error if request is nil
            return Fail(error: APIErrors.invalidRequestError(Constants.ErrorsMessages.invalidUrl))
                .eraseToAnyPublisher()
        }
        
        // use dataTaskPublisher to call the api for url request
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapping error related to invalid format or key values or data limitations
            .mapError { error -> Error in
                return APIErrors.transportError(error)
            }
            // map data and reponse and return
            // after getting response as HTTPURLResponse
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                return try self.getHttpURLResponse(requestType: requestType, response: response, data: data)
            }
            .map(\.data)
            .tryMap { data in
                // initialize json decoder
                let decoder = JSONDecoder()
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print(json)
                    }
                    return try decoder.decode(RidesSearchModel.self, from: data)
                } catch {
                    throw APIErrors.decodingError(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /// method for ride booking and publishing
    /// - Parameters:
    ///   - httpMethod: method for api request
    ///   - data: data that needs to be sent with api
    ///   - requestType: type of api request
    /// - Returns: any published with either response as PlacesDataModel or Error
    func createApiRequestForRides(httpMethod: HttpMethod, data: [String: Any], requestType: RequestType) -> AnyPublisher<BookRideModel, Error> {
        
        NetworkMonitor.shared.startMonitoring()
        if NetworkMonitor.shared.isReachable {
            NetworkMonitor.shared.stopMonitoring()
            return Fail(error: APIErrors.noInternet(Constants.ErrorsMessages.noInternetConnection))
                .eraseToAnyPublisher()
        }
        NetworkMonitor.shared.stopMonitoring()
        
        // get url request from setUpApiRequest method
        guard let request = setUpApiRequest(
            httpMethod  : httpMethod,
            data        : data,
            requestType : requestType
        ) else {
            // return error if request is nil
            return Fail(error: APIErrors.invalidRequestError(Constants.ErrorsMessages.invalidUrl))
                .eraseToAnyPublisher()
        }
        
        // use dataTaskPublisher to call the api for url request
        return URLSession.shared.dataTaskPublisher(for: request)
            // mapping error related to invalid format or key values or data limitations
            .mapError { error -> Error in
                return APIErrors.transportError(error)
            }
            // map data and reponse and return
            // after getting response as HTTPURLResponse
            .tryMap { (data, response) -> (data: Data, response: URLResponse) in
                return try self.getHttpURLResponse(requestType: requestType, response: response, data: data)
            }
            .map(\.data)
            .tryMap { data in
                // initialize json decoder
                let decoder = JSONDecoder()
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        print(json)
                    }
                    return try decoder.decode(BookRideModel.self, from: data)
                } catch {
                    throw APIErrors.decodingError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
