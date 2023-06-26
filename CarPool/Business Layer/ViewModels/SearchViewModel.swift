//
//  SearchViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import Foundation
import Combine

/// view model for search properties and methods
class SearchViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: private properties
    private var anyCancellable: AnyCancellable?
    
    // MARK: published properties
    // properties for search fields
    // start location
    @Published var startLocation: String = ""
    // end location
    @Published var endLocation: String = ""
    // data of departure
    @Published var dateOfDeparture: Date = Globals.defaultDateCurrent
    // number of persons
    @Published var numberOfPersons: String = Constants.Placeholders.one
    
    // boolean to open close active search view
    @Published var activeSearchView: Bool = false
    // boolean to open close search results view
    @Published var showSearchResults: Bool = false
    // boolean to open ride detail view
    @Published var showRideDetailView: Bool = false
    // boolean to show ride book summary view
    @Published var openSummaryView: Bool = false
    
    @Published var bookedSuccess: Bool = false
    
    // variable to store type of input field in search view
    // used to know type of input given by user in a same view
    @Published var searchComponentType: SearchInputsIdentifier = .startLocation
    
    // array to store places suggestions
    @Published var suggestions: [Candidate] = []
    // array to store search results
    @Published var searchResults: [Datum] = []
    
    // MARK: instance variables
    // shared instance of base view model
    var baseViewModel = BaseViewModel.shared
    
    // selected start location value
    @Published var startLocationVal: Candidate?
    // selected end location value
    @Published var endLocationVal: Candidate?
    
    @Published var recenltyViewedRides: [Datum] = []
    
    init() {
        getRecentlyViewedRides()
    }
    
    // MARK: - method
    
    // MARK: utility methods
    /// method to set input field values
    func setInputFieldValue() {
        switch searchComponentType {
        case .startLocation:
            if startLocationVal == nil {
                startLocation = ""
            }
        case .endLocation:
            if endLocationVal == nil {
                endLocation = ""
            }
        default:
            break
        }
    }
    
    /// method to validate input search field and call api request function
    func validateSearchInput() {
        if startLocation.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.emptyStartLocation
        } else if endLocation.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.emptyEndLocation
        } else {
            // check if startLocation and endLocation are not nil
            if let startLocationVal, let endLocationVal {
                print(startLocationVal.formattedAddress, endLocationVal.formattedAddress)
                // create data using all properties
                let data : [String : Any] = [
                    Constants.JsonKeys.sourceLongitude      : startLocationVal.geometry.location.lng,
                    Constants.JsonKeys.sourceLatitude       : startLocationVal.geometry.location.lat,
                    Constants.JsonKeys.destinationLongitude : endLocationVal.geometry.location.lng,
                    Constants.JsonKeys.destinationLatitude  : endLocationVal.geometry.location.lat,
                    Constants.JsonKeys.passengersCount      : numberOfPersons,
                    Constants.JsonKeys.date                 : Globals.dateFormatter.string(from: dateOfDeparture)
                ]
                // send request for search
                sendRequestForSearch(
                    httpMethod  : .GET,
                    requestType : .searchRides,
                    data        : data
                )
            }
        }
    }
    
    // MARK: method to send api requests
    /// method to send api request and get search results for rides published on application
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestForSearch(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        // empty search results before sending api request
        searchResults = []
        // call getSearchResults in ApiManager class
        anyCancellable = ApiManager.shared.getSearchResults(
            httpMethod  : httpMethod,
            data        : data,
            requestType : requestType
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
            // add response data in searchResults array
            for result in response.data {
                self?.searchResults.append(result)
            }
            // toggle searchShowResults to open search results view
            self?.showSearchResults.toggle()
        }
    }
    
    /// method to send api request for ride book
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestForRideBook(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        
        baseViewModel.inProgess = true
        openSummaryView = false
        
        // call getSearchResults in ApiManager class
        anyCancellable = ApiManager.shared.createApiRequestForRides(
            httpMethod  : httpMethod,
            data        : data,
            requestType : requestType
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
            
            self.baseViewModel.disableProgress()
        } receiveValue: { [weak self] response in
            print(response)
            if response.code == 201 {
                self?.baseViewModel.toastMessage = "Ride booked successfully"
                
                self?.bookedSuccess.toggle()
                
                self?.startLocation = ""
                self?.endLocation = ""
                self?.dateOfDeparture = Globals.defaultDateCurrent
                self?.numberOfPersons = Constants.Placeholders.one
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self?.showRideDetailView.toggle()
                    self?.showSearchResults.toggle()
                }
            } else {
                self?.baseViewModel.toastMessage = response.error ?? ""
            }
            
            self?.baseViewModel.disableProgress()
        }
    }
    
    /// method to send api request for getting places data using google places api
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestForGettingPlacesData(httpMethod: HttpMethod, requestType: RequestType, data: String) {
        // empty suggestions before sending api request
        suggestions = []
        // call getPlacesData in ApiManager class
        anyCancellable = ApiManager.shared.getPlacesData(
            httpMethod  : httpMethod,
            text        : data,
            requestType : requestType
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
            // add response to suggestions array
            for address in response.candidates {
                self?.suggestions.append(address)
            }
        }
    }
    
    /// update recent searches in user defaults
    /// - Parameter data: search result data
    func updateRecentlyViewedRides(data: Datum?) {
        
        var recentlyViewed: [Data] = []
        
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(data) else {
            return
        }
        
        if let data = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.recentViewedRides) as? [Data] {
            recentlyViewed = data
        }
        
        for data in recentlyViewed {
            if encoded == data {
                return
            }
        }
        
        if recentlyViewed.count >= 10 {
            recentlyViewed.removeSubrange(9..<recentlyViewed.count)
        }
        
        recentlyViewed.insert(encoded, at: 0)
        
        UserDefaults.standard.set(recentlyViewed, forKey: Constants.UserDefaultKeys.recentViewedRides)
        
        getRecentlyViewedRides()
    }
    
    func getRecentlyViewedRides() {
        guard let savedData = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.recentViewedRides) as? [Data] else {
            return
        }
        
        var recents: [Datum] = []
        
        for data in savedData {
            if let jsonData = try? JSONDecoder().decode(Datum.self, from: data) {
                recents.append(jsonData)
            }
        }
        
        self.recenltyViewedRides = recents
    }
}
