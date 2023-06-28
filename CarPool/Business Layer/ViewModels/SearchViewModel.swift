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
    @Published var findRide: Bool = true
    // start location
    @Published var startLocation: String = ""
    // end location
    @Published var endLocation: String = ""
    // data of departure
    @Published var dateOfDeparture: Date = Globals.defaultDateCurrent
    // number of persons
    @Published var numberOfPersons: String = Constants.Placeholders.one
    // vehicle
    @Published var selectedVehicle: String = ""
    @Published var selectedVehicleId: Int = 0
    // price
    @Published var pricePerSeat: String = ""
    // estimated time
    @Published var estimatedTime: String = ""
    
    // boolean to open close active search view
    @Published var activeSearchView: Bool = false
    // boolean to open close search results view
    @Published var showSearchResults: Bool = false
    // boolean to open ride detail view
    @Published var showRideDetailView: Bool = false
    @Published var showRideDetailViewFromRecents: Bool = false
    // boolean to show ride book summary view
    @Published var openSummaryView: Bool = false
    
    @Published var bookedSuccess: Bool = false
    
    // variable to store type of input field in search view
    // used to know type of input given by user in a same view
    @Published var searchComponentType: SearchInputsIdentifier = .price
    
    // array to store places suggestions
    @Published var suggestions: [Candidate] = []
    // array to store searchHistory
    @Published var searchHistory: [Candidate] = []
    // array to store search results
    @Published var searchResults: [Datum] = []
    
    @Published var ridePublishOrBook: RidePublishedOrBook = RidePublishedOrBook(title: "", caption: "")
    
    // MARK: instance variables
    // shared instance of base view model
    var baseViewModel = BaseViewModel.shared
    
    // selected start location value
    @Published var startLocationVal: Candidate?
    // selected end location value
    @Published var endLocationVal: Candidate?
    
    @Published var recenltyViewedRides: [Datum] = []
    
    @Published var openMapView: Bool = false
    
    var buttonText: String {
        findRide ? Constants.Search.search : Constants.Search.proceed
    }
    
    init() {
        getRecentlyViewed(key: Constants.UserDefaultKeys.recentViewedRides)
        getRecentlyViewed(key: Constants.UserDefaultKeys.recentSearches)
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
                
                if findRide {
                    // create data using all properties
                    let data : [String : Any] = [
                        Constants.JsonKeys.sourceLongitude      : startLocationVal.geometry.location.lng,
                        Constants.JsonKeys.sourceLatitude       : startLocationVal.geometry.location.lat,
                        Constants.JsonKeys.destinationLongitude : endLocationVal.geometry.location.lng,
                        Constants.JsonKeys.destinationLatitude  : endLocationVal.geometry.location.lat,
                        Constants.JsonKeys.passengersCount      : numberOfPersons,
                        Constants.JsonKeys.date                 : dateOfDeparture.formatted(date: .numeric, time: .omitted)
                    ]
                    // send request for search
                    sendRequestForSearch(
                        httpMethod  : .GET,
                        requestType : .searchRides,
                        data        : data
                    )
                } else {
                    validatePublishRidesInput()
                    
                    if baseViewModel.toastMessage.isEmpty {
                        openMapView.toggle()
                    }
                }
            }
        }
    }
    
    func publishRide() {
        
        if let startLocationVal, let endLocationVal {
            let data : [String : Any] = [
                "source": startLocationVal.formattedAddress,
                "destination": endLocationVal.formattedAddress,
                "source_longitude": startLocationVal.geometry.location.lng,
                "source_latitude": startLocationVal.geometry.location.lat,
                "destination_longitude": endLocationVal.geometry.location.lng,
                "destination_latitude": endLocationVal.geometry.location.lat,
                "passengers_count": numberOfPersons,
                "date": Globals.dateFormatter.string(from: dateOfDeparture),
                "time": dateOfDeparture.formatted(date: .omitted, time: .shortened),
                "set_price": pricePerSeat,
                "about_ride": "",
                "vehicle_id": selectedVehicleId,
                "book_instantly": true,
                "mid_seat": false,
                "estimate_time": estimatedTime,
                "select_route": []
            ]
            
            // send request for search
            sendRequestForSearch(
                httpMethod  : .POST,
                requestType : .publishRides,
                data        : ["publish" : data]
            )
        }
    }
    
    func validatePublishRidesInput() {
        if selectedVehicle.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.pleaseSelectVehicle
        } else if pricePerSeat.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.pleaseSetPrice
        }
    }
    
    // MARK: method to send api requests
    /// method to send api request and get search results for rides published on application
    /// - Parameters:
    ///   - httpMethod: http method for sending api request
    ///   - requestType: type of request ex .login, .signup etc.
    func sendRequestForSearch(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        baseViewModel.inProgess = true
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
                self.baseViewModel.toastMessage = error.localizedDescription
            case .finished:
                print("success")
            }
        } receiveValue: { [weak self] response in
            // add response data in searchResults array
            if requestType == .publishRides {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self?.openMapView == true {
                        self?.openMapView.toggle()
                    }
                }
                
                self?.baseViewModel.toastMessage = "Ride created successfully"
                self?.ridePublishOrBook = RidePublishedOrBook(title: "You'r ride is successfully published. ✅", caption: "Relax, sit back and wait for people to book your ride.")
                
                self?.bookedSuccess.toggle()
                self?.resetData()
                
            } else {
                if let data = response.data {
                    for result in data {
                        self?.searchResults.append(result)
                    }
                }
                
                // toggle searchShowResults to open search results view
                self?.showSearchResults.toggle()
            }
            self?.baseViewModel.inProgess = false
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
                self?.ridePublishOrBook = RidePublishedOrBook(title: "You'r ride is successfully booked. ✅", caption: "Relax, we've sent information about your ride to the ride publisher.")
                self?.bookedSuccess.toggle()
                self?.resetData()
                
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    if self?.showRideDetailView == true {
                        self?.showRideDetailView.toggle()
                    }
                    if self?.showRideDetailViewFromRecents == true {
                        self?.showRideDetailViewFromRecents.toggle()
                    }
                    if self?.showSearchResults == true {
                        self?.showSearchResults.toggle()
                    }
                }
            } else {
                self?.baseViewModel.toastMessage = response.error ?? ""
            }
            
            self?.baseViewModel.disableProgress()
        }
    }
    
    func resetData() {
        
        self.startLocation = ""
        self.endLocation = ""
        self.dateOfDeparture = Globals.defaultDateCurrent
        self.numberOfPersons = Constants.Placeholders.one
        self.selectedVehicle = ""
        self.selectedVehicleId = 0
        self.pricePerSeat = ""
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
        
        for data in recentlyViewed where encoded == data {
            return
        }
        
        if recentlyViewed.count >= 10 {
            recentlyViewed.removeSubrange(9..<recentlyViewed.count)
        }
        recentlyViewed.insert(encoded, at: 0)
        UserDefaults.standard.set(recentlyViewed, forKey: Constants.UserDefaultKeys.recentViewedRides)
        getRecentlyViewed(key: Constants.UserDefaultKeys.recentViewedRides)
    }
    
    /// method to update recent searches data
    /// - Parameters:
    ///   - data: data to be added or removed
    ///   - delete: boolean to check if request's for deltion or addition
    func updateRecentSearched(data: Candidate, delete: Bool) {
        var recentlySearched: [Data] = []
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(data) else {
            return
        }
        
        if let data = UserDefaults.standard.object(forKey: Constants.UserDefaultKeys.recentSearches) as? [Data] {
            recentlySearched = data
        }
        
        if delete {
            for (index, data) in recentlySearched.enumerated() where encoded == data {
                recentlySearched.remove(at: index)
            }
        } else {
            for data in recentlySearched where encoded == data {
                return
            }
            if recentlySearched.count >= 5 {
                recentlySearched.removeSubrange(4..<recentlySearched.count)
            }
            recentlySearched.insert(encoded, at: 0)
        }
        UserDefaults.standard.set(recentlySearched, forKey: Constants.UserDefaultKeys.recentSearches)
        getRecentlyViewed(key: Constants.UserDefaultKeys.recentSearches)
    }
    
    /// get recent searches and rides history
    /// - Parameter key: key for user defaults
    func getRecentlyViewed(key: String) {
        guard let savedData = UserDefaults.standard.object(forKey: key) as? [Data] else {
            return
        }
        if key == Constants.UserDefaultKeys.recentSearches {
            var recents: [Candidate] = []
            for data in savedData {
                if let jsonData = try? JSONDecoder().decode(Candidate.self, from: data) {
                    recents.append(jsonData)
                }
            }
            self.searchHistory = recents
        } else if key == Constants.UserDefaultKeys.recentViewedRides {
            var recents: [Datum] = []
            for data in savedData {
                if let jsonData = try? JSONDecoder().decode(Datum.self, from: data) {
                    let now = Date.now
                    
                    if let date = Globals.dateFormatter.date(from: jsonData.publish.date ?? "") {
                        if now < date {
                            recents.append(jsonData)
                        }
                    }
                }
            }
            self.recenltyViewedRides = recents
        }
    }
}

class RidePublishedOrBook {
    let title: String
    let caption: String
    
    init(title: String, caption: String) {
        self.title = title
        self.caption = caption
    }
}
