//
//  SearchViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    
    // MARK: - properties
    
    private var anyCancellable: AnyCancellable?
    
    // MARK: booleans for presenting views
    
    @Published var findRide: Bool = true
    // active search
    @Published var activeSearchView: Bool = false
    // search results
    @Published var showSearchResults: Bool = false
    // ride detail
    @Published var showRideDetailView: Bool = false
    // ride detail from recents
    @Published var showRideDetailViewFromRecents: Bool = false
    // ride book summary
    @Published var openSummaryView: Bool = false
    // book success
    @Published var bookedSuccess: Bool = false
    // map view
    @Published var openMapView: Bool = false
    // progress bar view
    @Published var showProgressView = false
    
    // MARK: instance variables
    
    var baseViewModel = BaseViewModel.shared
    var ridePublishOrBook: RidePublishedOrBook = RidePublishedOrBook(title: "", caption: "")
    
    // MARK: selected values
    
    // selected search component
    @Published var searchComponentType: SearchInputsIdentifier = .price
    // selected start location value
    @Published var startLocationVal: Candidate?
    // selected end location value
    @Published var endLocationVal: Candidate?
    
    // MARK: computed properties
    
    var buttonText: String {
        findRide ? Constants.Search.search : Constants.Search.proceed
    }
    
    // MARK: input field values
    
    // start location
    @Published var startLocation: String = ""
    // end location
    @Published var endLocation: String = ""
    // data of departure
    @Published var dateOfDeparture: Date = Formatters.defaultDateCurrent
    // number of persons
    @Published var numberOfPersons: String = Constants.Placeholders.one
    // vehicle
    @Published var selectedVehicle: String = ""
    // vehicle id
    @Published var selectedVehicleId: Int = 0
    // price
    @Published var pricePerSeat: String = ""
    // estimated time
    @Published var estimatedTime: String = ""
    
    // MARK: variables to store data returned from api
    
    // google places suggestions
    @Published var suggestions: [Candidate] = []
    // search history
    @Published var searchHistory: [Candidate] = []
    // search results
    @Published var searchResults: [Datum] = []
    // recelty viewed rides
    @Published var recenltyViewedRides: [Datum] = []
    // published rides data
    @Published var publishedRidesData: [Publish] = []
    // booked rides data
    @Published var bookedRidesData: [BookedRidesData] = []
    
    // MARK: - initializers
    
    /// default initializer
    init() {
        getRecentlyViewed(key: Constants.UserDefaultKeys.recentViewedRides)
        getRecentlyViewed(key: Constants.UserDefaultKeys.recentSearches)
    }
    
    // MARK: - methods
    
    /// method to send api request for getting places data using google places
    /// - Parameters:
    ///   - httpMethod: http method for api
    ///   - requestType: type of api request
    func sendRequestForGettingPlacesData(httpMethod: HttpMethod, requestType: RequestType, data: String) {
        showProgressView = true
        suggestions = []
        
        anyCancellable = ApiManager.shared.getPlacesData(
            httpMethod  : httpMethod,
            text        : data,
            requestType : requestType
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                print("ERROR: \(error)")
                self.baseViewModel.toastMessage = error.localizedDescription
            case .finished:
                print("success")
            }
            
            self.showProgressView = false
        } receiveValue: { [weak self] response in
            self?.suggestions = response.candidates
        }
    }
    
    /// method to for searching rides and pubilsh a new ride
    /// - Parameters:
    ///   - httpMethod: http method for api
    ///   - requestType: type of api request
    func sendRequestForSearchAndPublish(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        baseViewModel.inProgess = true
        searchResults = []
        
        anyCancellable = ApiManager.shared.apiRequestSearchAndRides(httpMethod: httpMethod, data: data, requestType: requestType)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                print("ERROR: \(error)")
                self.baseViewModel.toastMessage = error.localizedDescription
            case .finished:
                print("success")
            }
        } receiveValue: { [weak self] response in
            self?.handleSearchAndPublish(requestType: requestType, httpMethod: httpMethod, response: response)
        }
    }
    
    /// method to send api request to book a ride
    /// - Parameters:
    ///   - httpMethod: http method for api
    ///   - requestType: type of api request
    func sendRequestForRideBook(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        baseViewModel.inProgess = true
        openSummaryView = false
        
        anyCancellable = ApiManager.shared.apiRequestSearchAndRides(httpMethod: httpMethod, data: data, requestType: requestType)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                print("ERROR: \(error)")
                self.baseViewModel.toastMessage = error.localizedDescription
            case .finished:
                print("success")
            }
        } receiveValue: { [weak self] response in
            self?.handleBookRide(requestType: requestType, httpMethod: httpMethod, response: response)
        }
    }
    
    /// method to get published rides data
    /// - Parameters:
    ///   - httpMethod: http method for api
    ///   - requestType: type of api request
    func sendRequestToGetPublished(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        anyCancellable = ApiManager.shared.apiRequestSearchAndRides(httpMethod: httpMethod, data: data, requestType: requestType)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                print("ERROR: \(error)")
                self.baseViewModel.toastMessage = error.localizedDescription
            case .finished:
                print("success")
            }
        } receiveValue: { [weak self] response in
            self?.getPublishedRides(response: response)
        }
    }
    
    /// method to get booked rides data
    /// - Parameters:
    ///   - httpMethod: http method for api
    ///   - requestType: type of api request
    func sendRequestToGetBooked(httpMethod: HttpMethod, requestType: RequestType, data: [String: Any]) {
        anyCancellable = ApiManager.shared.apiRequestSearchAndRides(httpMethod: httpMethod, data: data, requestType: requestType)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            switch completion {
            case .failure(let error):
                print("ERROR: \(error)")
                self.baseViewModel.toastMessage = error.localizedDescription
            case .finished:
                print("success")
            }
        } receiveValue: { [weak self] response in
            self?.getBookedRides(response: response)
        }
    }
}
