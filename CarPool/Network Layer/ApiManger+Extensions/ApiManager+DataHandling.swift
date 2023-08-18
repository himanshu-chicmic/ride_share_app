//
//  ApiManager+DataHandling.swift
//  CarPool
//
//  Created by Himanshu on 6/3/23.
//

import Foundation
import UIKit

/// extension for ApiMangerClass
/// contains methods related to data handling and decoding
extension ApiManager {
    
    // MARK: - methods for creating data
    
    /// method to create the body of data for sending the
    /// image, and other details of user to the server
    /// used in only put request for sending the user data
    /// - Parameter params: data dictionary
    /// - Returns: body of type Data
    func createDataBody(withParameters params: [String: Any?]) -> Data {
        // initialize data object
        var body = Data()
        // constant string struct
        let dataBodyStrings = ApiConstants.StringForDataBody.self
        
        // loop over params dictionary
        for (key, value) in params {
            // append boundary with a line break
            body.append(dataBodyStrings.boudaryWithLineBreakTwoHyphens)
            // check if value if not nil
            if let value = value {
                // check if key is for imageURL
                if key == Constants.JsonKeys.image {
                    // get image as UIImage
                    if let image = value as? UIImage {
                        let imageFileName = BaseViewModel.shared.userData?.status.data?.firstName ?? Constants.Images.defaultImageName
                        body.append(String(format: dataBodyStrings.imageContentDisposition, key, imageFileName))
                        body.append(String(format: dataBodyStrings.imageContentType, dataBodyStrings.imageMimePng))
                        // get data of image by compressing image
                        if let data = image.jpegData(compressionQuality: 0.25) {
                            body.append(data)
                            body.append(dataBodyStrings.lineBreak)
                        }
                    }
                }
            }
        }
        body.append(dataBodyStrings.boudaryWithLineBreakFourHyphens)
        // return data body
        return body
    }
    
    // MARK: - methods for session token
    
    /// method to set authorization token for signup, login or logout requests
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - response: response from the api
    func setSessionToken(requestType: RequestType, response: HTTPURLResponse) {
        if requestType == .logOut {
            // remove all data from user defaults
            UserDefaults.standard.set("", forKey: Constants.UserDefaultKeys.session)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.profileData)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.vehiclesData)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.recentViewedRides)
            UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.recentSearches)
        }
        // else for request type login or signin get the bearer token from the reponse and
        // set the user default for SessionAuthToken
        else if requestType == .signUp || requestType == .logIn {
            // get token from response header
            let bearer = response.value(forHTTPHeaderField: ApiConstants.HTTPHeaderFieldAndValues.authorization)
            if let bearer {
                UserDefaults.standard.set(bearer, forKey: Constants.UserDefaultKeys.session)
            }
        }
    }
    
    // MARK: - methods for decoding data
    
    /// method to get HttpUrlResponse and set session token by using it
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - response: response from url request containts header fields
    ///   - data: data returned from api request
    /// - Returns: a tuple of (Data, URLResponse) type
    func getHttpURLResponse(requestType: RequestType, response: URLResponse, data: Data) throws -> (Data, URLResponse) {
        // get reponse as HTTPURLResponse
        guard let response = response as? HTTPURLResponse else {
            // else throw error as invalid response
            throw APIErrors.invalidResponse
        }
        // set sessino token for three types of request. signup, logi and logout

        if requestType == .signUp || requestType == .logIn || requestType == .logOut {
            // call set session token method to set authorization token
            // for login signup or logout requests
            self.setSessionToken(
                requestType : requestType,
                response    : response
            )
        }
        
        // return data and response
        return (data, response)
    }
    
    /// method to decode data from signin response using json decoder and set to user defaults is reponse code is 200
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - data: data retunred from api
    /// - Returns: instance of SignInAndProfileModel
    func decodeSignInRequestData(requestType: RequestType, data: Data) throws -> SignInAndProfileModel {
        // decoding data to SignInAndProfileModel
        let response = try JSONDecoder().decode(SignInAndProfileModel.self, from: data)
        
        // check if request type equals any one of .getDetails, .signUp, .updateProfile
        // to set data in user defaults
        if requestType == .getDetails || requestType == .signUp || requestType == .updateProfile {
            // if response is success set data to user default
            if response.status.code == 200 {
                UserDefaults.standard.set(data, forKey: Constants.UserDefaultKeys.profileData)
            }
        }
        // return decoded response
        return response
    }
    
    /// method to handle data which is not compatible with SignInAndProfileModel
    /// by using json serialization to set the required response model manualy and returning that response
    /// if status code of request response is ok i.e. 200
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - data: data returned from api
    ///   - error: throwable error from catch block
    /// - Returns: instance of SignInAndProfileModel
    func decodeSignInRequestAdditionalData(requestType: RequestType, data: Data, error: Error) throws -> SignInAndProfileModel {
        // initialize status struct instance with code 404
        var status = Status(code: 404, error: nil, errors: nil, data: nil, imageURL: nil)
        
        switch requestType {
        case .emailCheck:
            // set status code with data count because data count will be 0 when the email doesn't exists
            // and available for signup
            status.code = data.count
        case .logOut:
            // serialize data to get json dictionary of response returned from api
            guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw APIErrors.decodingError(error)
            }
            // set status code and message for logout
            status.code = json[Constants.JsonKeys.status] as? Int ?? 0
            status.message = json[Constants.JsonKeys.message] as? String
        case .confirmEmail:
            status.code = 0
        default:
            throw APIErrors.decodingError(error)
        }
        // return response
        return SignInAndProfileModel(status: status)
    }
    
    /// method to decode vehicles data returned from api
    /// - Parameters:
    ///   - httpMethod: http request method type
    ///   - data: data returned from api
    /// - Returns: data in form of VehiclesDataModel
    func decodeVehiclesRequestData(httpMethod: HttpMethod, data: Data, requestType: RequestType) throws -> VehiclesDataModel {
        
        if requestType == .getVehicleById {
            let json = try JSONDecoder().decode(VehiclesDataClass.self, from: data)
            // return the response
            return VehiclesDataModel(
                status: VehiclesStatus(
                    code    : 200,
                    message : nil,
                    data    : [json]
                )
            )
        }
        
        // get json by serializing json data in [String: Any] format
        let json = try JSONSerialization.jsonObject(
            with    : data,
            options : []
        ) as? [String: Any]
        // variable jsonData stores json if not status key if found
        // else it will get response inside "status" key
        let jsonData = json?[Constants.JsonKeys.status] as? [String : Any] ?? json
        // for method type of get set the data of vehicles
        if httpMethod == .GET {
            UserDefaults.standard.set(data, forKey: Constants.UserDefaultKeys.vehiclesData)
        }
        // get status code and data from response
        let code = jsonData?[Constants.JsonKeys.code] as? Int ?? 404
        let data = jsonData?[Constants.JsonKeys.data] as? [VehiclesDataClass]

        // return the response
        return VehiclesDataModel(
            status: VehiclesStatus(
                code    : code,
                message : nil,
                data    : data
            )
        )
    }
}
