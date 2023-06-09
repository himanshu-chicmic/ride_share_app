//
//  BaseViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI
import Combine

class BaseViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: static shared instance
    
    static let shared = BaseViewModel()
    
    // MARK: private properties
    
    private var cancellables: AnyCancellable?
    
    // MARK: published properties
    
    // var for error/validaton messages
    // to be shown on a error dialog box
    @Published var toastMessage: String = "" {
        // did set property
        // observers any changes in toastMessage property
        didSet {
            // if toast message is not empyt
            if !toastMessage.isEmpty {
                // call dismiss method for toast
                dismissToastInThreeSeconds()
            }
        }
    }
    
    // var to know if the screen is processing
    // information and show a progress view
    @Published var inProgess: Bool = false
    
    // open view for user detials
    @Published var openUserDetailsView: Bool = false
    
    // open edit details for vehicles or profile
    @Published var editProfile = false
    @Published var addVehicle = false
    
    // open forgot password view
    @Published var openForgotPasswordView: Bool = false
    
    // update single profile item
    @Published var openAddProfile: Bool = false
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @Published var switchToDashboard = false
    
    // variable to switch between view otp field and hide otp field
    @Published var viewOtpField = false
    
    // single vehicle value
    @Published var singleVehicleData: VehiclesDataModel?
    
    // MARK: variable instances
    // instance for validations struct
    var validationsInstance = Validations()
    
    // MARK: computed properties
    // computed propert to get user's data
    var userData: SignInAndProfileModel? {
        // get profile data from user defaults
        guard let data = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.profileData) as? Data else {
            // return nil if not found
            return nil
        }
        // decode data into SignInAndProfileModel
        guard let loadedData = try? JSONDecoder().decode(SignInAndProfileModel.self, from: data) else {
            return nil
        }
        // return decoded data
        return loadedData
    }
    
    // compted property to get vehicles data
    var vehiclesData: VehiclesDataModel? {
        // get vehicles data form user defaults
        guard let data = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.vehiclesData) as? Data else {
            // return nil if not found
            return nil
        }
        // decode vehicle data
        do {
            // first convert to dictionary of type [String: Any]
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                // convert json["data"] into Data
                let data = try JSONSerialization.data(withJSONObject: json[Constants.JsonKeys.data]!, options: .fragmentsAllowed)
                
                // decode the encoded data in an array of VehiclesDataClass
                let list = try JSONDecoder().decode([VehiclesDataClass].self, from: data)
                // return resposne
                return VehiclesDataModel(status: VehiclesStatus(code: json[Constants.JsonKeys.code] as? Int ?? 0, message: nil, data: list))
            }
        } catch {
            return nil
        }
        // return nil if not found
        return nil
    }
        
    // MARK: - methods
    
    // MARK: method to send api requests
    
    /// method to send api request and observe changes
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestToApi(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        // set in progress to true for showing loader
        inProgess = true
        // call createApiRequest in ApiManager class
        cancellables = ApiManager.shared.createApiRequest(
            httpMethod     : httpMethod,
            dataDictionary : data,
            requestType    : requestType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            // switch completion to handle failure and success
            switch completion {
            case .failure(let error):
                // show failure info in form of toast
                self.toastMessage = error.localizedDescription
                print("ERROR: \(error)")
            case .finished:
                // show success info in form of toast
                print("success")
            }
            // disable the progress view once the completion has received
            self.disableProgress()
        } receiveValue: { [weak self] response in
            // check if response status code is 200 or 0 or show error message
            if response.status.code == 200 || response.status.code == 0 {
                // call function handleDataRespones to handle
                // the result returned from api
                self?.handleDataResponse(
                    userData : response,
                    type     : requestType
                )
            } else {
                // check and assign if error or message exists
                self?.toastMessage = response.status.error ?? response.status.message ?? ""
            }
        }
    }
    
    /// method to send api request and observe changes
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendVehiclesRequestToApi(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        // set in progress to true for showing loader
        inProgess = true
        // call createVehiclesApiRequest in ApiManager class
        cancellables = ApiManager.shared.createVehiclesApiRequest(
            httpMethod     : httpMethod,
            dataDictionary : data,
            requestType    : requestType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            // switch completion to handle
            // failure and finished cases
            switch completion {
            case .failure(let error):
                self.toastMessage = error.localizedDescription
                print("ERROR: \(error)")
            case .finished:
                print("success")
            }
            
            // disable the progress view once the completion has received
            self.disableProgress()
        } receiveValue: { [weak self] response in
            // check if response status code is 200 or show error message
            if response.status.code == 200 || response.status.code == 201 {
                // call function handleDataRespones to handle
                // the result returned from api
                self?.handleDataResponse(
                    vehiclesData : response,
                    type         : requestType
                )
            } else {
                // check and assign if error message exists
                self?.toastMessage = response.status.message ?? ""
            }
        }
    }
}
