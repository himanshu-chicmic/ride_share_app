//
//  SearchViewModel+DataHandling.swift
//  CarPool
//
//  Created by Himanshu on 6/29/23.
//

import Foundation

extension SearchViewModel {
    
    /// method to handle search and published request data
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - httpMethod: http method for api call
    ///   - response: data returned from api
    func handleSearchAndPublish(requestType: RequestType, httpMethod: HttpMethod, response: RidesSearchModel) {
        if requestType == .publishedRides && httpMethod != .GET {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.openMapView.toggle()
            }
            ridePublishOrBook = RidePublishedOrBook(title: Constants.InfoMessages.successfullyPublished, caption: Constants.InfoMessages.successPubishedCaption)
            bookedSuccess.toggle()
            
            resetData()
            sendRequestToGetPublished(httpMethod: .GET, requestType: .publishedRides, data: [:])
        } else {
            if let data = response.data {
                for result in data {
                    searchResults.append(result)
                }
            }
            showSearchResults.toggle()
        }
        baseViewModel.inProgess = false
    }
    
    /// method to handle booked ride response data
    /// - Parameters:
    ///   - requestType: type of api request
    ///   - httpMethod: http method for api call
    ///   - response: data resturned from api
    func handleBookRide(requestType: RequestType, httpMethod: HttpMethod, response: BookRideModel) {
        if response.code == 201 {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                self.showRideDetailView = false
                self.showRideDetailViewFromRecents = false
                self.showSearchResults = false
            }
            ridePublishOrBook = RidePublishedOrBook(title: Constants.InfoMessages.rideBookSuccessTitle, caption: Constants.InfoMessages.rideBookSuccessCaption)
            bookedSuccess.toggle()
            
            resetData()
            sendRequestToGetBooked(httpMethod: .GET, requestType: .bookedRides, data: [:])
        } else {
            baseViewModel.toastMessage = response.error ?? ""
        }
        baseViewModel.inProgess = false
    }
    
    /// method to fetch published rides
    /// - Parameter response: PublishedRidesModel data
    func getPublishedRides(response: PublishedRidesModel) {
        publishedRidesData = response.data.reversed()
    }
    
    /// method to fetch booked rides
    /// - Parameter response: BookedRidesModel data
    func getBookedRides(response: BookedRidesModel) {
        bookedRidesData = response.rides.reversed()
    }
}
