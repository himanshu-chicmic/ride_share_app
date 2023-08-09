//
//  ApiManager+SetURLRequests.swift
//  CarPool
//
//  Created by Himanshu on 6/3/23.
//

import Foundation

/// extension for ApiManager class
/// contains methods for url requests
extension ApiManager {
    
    // MARK: - methods to set up api request
    
    /// method to set up api request and return it as url request
    /// - Parameters:
    ///   - endPoint: string value of api endpoint. used with base api url to form a valid url
    ///   - httpMethod: method of api request i.e. get, post, delete, put
    ///   - data: dictionary for sending some json data alog with api
    ///   - requestType: type of request i.e. signup, login, email check etc.
    /// - Returns: a url request which is used to for url session
    func setUpApiRequest(httpMethod: HttpMethod, data: [String: Any], requestType: RequestType) -> URLRequest? {
        
        // initialzie data variable for changes during vehicles request
        var data = data
        // create a base url
        var baseURL = String(format: ApiConstants.baseURL, requestType.rawValue)
        
        // if http method is of type get
        // then we need to add query with base url
        if httpMethod == .GET || httpMethod == .DELETE || httpMethod == .PUT {
            setGetRequestURL(
                requestType : requestType,
                baseURL     : &baseURL,
                data        : &data
            )
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
        // set the token value to request headers by fetching
        // it from user defaults
        if let tokenValue = UserDefaults.standard.string(forKey: Constants.UserDefaultKeys.session) {
            if !tokenValue.isEmpty {
                // set token value necessary for authentication of session created by user on login
                request.setValue(tokenValue, forHTTPHeaderField: ApiConstants.HTTPHeaderFieldAndValues.authorization)
            }
        }
        
        // run this block only when request type is not of get type
        // as in get request no data body is sent and we don't need to
        // set any content-type
        if httpMethod != .GET {
            setRequestBody(
                requestType : requestType,
                request     : &request,
                data        : data
            )
        }
        
        // return url request
        return request
    }
    
    /// method to set get request by appending data to them
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - baseURL: base url
    ///   - data: data for adding to url request
    func setGetRequestURL(requestType: RequestType, baseURL: inout String, data: inout [String: Any]) {
        // if request type if of type email check
        // then our url need to be changed to handle the get request
        // in get request the data needs to be sent with the url
        if requestType == .emailCheck, let email = data[InputFieldIdentifier.email.rawValue] as? String {
            baseURL += String(format: ApiConstants.getRequestEmailCheck, email.lowercased())
        }
        // if requesst type is of delete vehicle or update send delete or update request
        // which needs id of vehicle as parameters in url
        else if requestType == .deleteVehicle || requestType == .updateVehicle || requestType == .getVehicleById || requestType == .updateRide {
            if let endpoint = data[Constants.JsonKeys.id] {
                baseURL += "/\(endpoint)"
            }
            // remove id from data in case of delete vehicle this doesn't matter
            // becaues no additional data will be send for delete request
            // and in case of update vehicle we don't need to update id of vehicle.
            data.removeValue(forKey: Constants.JsonKeys.id)
        }
        // if request is type of seach rides append data to url
        else if requestType == .searchRides {
            // variable use for starting a query
            var addQuery = true
            for (key, value) in data {
                if addQuery {
                    baseURL.append(String(format: ApiConstants.query, key, "\(value)"))
                    addQuery = false
                } else {
                    baseURL.append(String(format: ApiConstants.addToQuery, key, "\(value)"))
                }
            }
        }
    }
    
    /// method to set content type and http body for url request
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - request: url request for api
    ///   - data: data to be added in api request
    func setRequestBody(requestType: RequestType, request: inout URLRequest, data: [String: Any]) {
        // set content type
        // if request is type of upload image set content type as mutlipart-formdata
        if requestType == .uploadImage {
            request.setValue(ApiConstants.StringForDataBody.multipartFormData, forHTTPHeaderField: ApiConstants.HTTPHeaderFieldAndValues.contentType)
            // get data for image upload from create data body method
            request.httpBody = createDataBody(withParameters: data)
        }
        // else set application/json as the content type
        else {
            request.setValue(ApiConstants.HTTPHeaderFieldAndValues.applicationJson, forHTTPHeaderField: ApiConstants.HTTPHeaderFieldAndValues.contentType)
            request.httpBody = try? JSONSerialization.data(withJSONObject: data, options: .fragmentsAllowed)
        }
    }
}
