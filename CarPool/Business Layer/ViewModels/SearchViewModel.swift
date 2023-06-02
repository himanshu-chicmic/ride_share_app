//
//  SearchViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import Foundation
import Combine
import SwiftUI

/// view model for search properties and methods
class SearchViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: private properties
    var anyCancellable: AnyCancellable?
    
    // MARK: published properties
    @Published var startLocation: String = ""
    @Published var endLocation: String = ""
    
    var startLocationVal: Candidate?
    var endLocationVal: Candidate?
    
    @Published var dateOfDeparture: Date = Globals.defaultDateCurrent
    
    @Published var numberOfPersons: String = Constants.Placeholders.one
    
    @Published var activeSearchView: Bool = false
    @Published var searchComponentType: SearchInputsIdentifier = .startLocation
    
    @Published var showSearchResults: Bool = false
    
    @Published var suggestions: [Candidate] = []
    
    @Published var searchResults: [Datum] = []
    
    var baseViewModel = BaseViewModel.shared
    
    // MARK: - method
    
    // MARK: utility method
    func validateSearchInput() {
        if startLocation.isEmpty {
            baseViewModel.toastMessage = "Enter a start location"
        } else if endLocation.isEmpty {
            baseViewModel.toastMessage = "Enter an end location"
        } else {
            let data : [String : Any] = [
                "source_longitude": startLocationVal?.geometry.location.lng ?? 30.71326,
                "source_latitude": startLocationVal?.geometry.location.lat ?? 76.69106,
                "destination_longitude": endLocationVal?.geometry.location.lng ?? 82.9739,
                "destination_latitude": endLocationVal?.geometry.location.lat ?? 25.3176,
                "pass_count": Int(numberOfPersons) ?? 1,
                "date": Globals.dateFormatter.string(from: dateOfDeparture)
            ]
                
            sendRequestToForSearch(httpMethod: .GET, requestType: .searchRides, data: data)
        }
    }
    
    // MARK: method to send api requests
    /// method to send api request and observe changes
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestToForSearch(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        
        searchResults = []
        // call signInUserMethod in ApiManager class
        anyCancellable = ApiManager.shared.getSearchResults(httpMethod: httpMethod, data: data, requestType: requestType)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            // switch completion to handle
            // failure and finished cases
            switch completion {
            case .failure(let error):
                print("ERROR: \(error)")
            case .finished:
                print("success")
            }
            
        } receiveValue: { [weak self] response in
            for result in response.data {
                self?.searchResults.append(result)
            }
            
            self?.showSearchResults.toggle()
        }
    }
    
    // MARK: method to send api requests
    /// method to send api request and observe changes
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestToApi(httpMethod: HttpMethod, requestType: RequestType, data: String) {
        // call signInUserMethod in ApiManager class
        anyCancellable = ApiManager.shared.getPlacesData(
            httpMethod      : httpMethod,
            text  : data,
            requestType     : requestType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            // switch completion to handle
            // failure and finished cases
            switch completion {
            case .failure(let error):
                print("ERROR: \(error)")
            case .finished:
                print("success")
            }
            
        } receiveValue: { [weak self] response in
            self?.suggestions = []
            for address in response.candidates {
                self?.suggestions.append(address)
            }
        }
    }
}
