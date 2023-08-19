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
            self.baseViewModel.toastMessageBackground = .red
            baseViewModel.toastMessage = response.error ?? ""
        }
    }
    
    /// method to assign single published ride data
    /// - Parameter response: PublishedRidesSingleModel data
    func getPublishedSingleRide(response: PublishedRidesSingleModel) {
        publishedRideSingleData = response
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
    
    /// method to update ride's data
    /// - Parameter response: response of api request for data change
    func updateRide(response: RidesSearchModel, requestType: RequestType) {
        if response.code == 200 {
            editRideView = false
            if showRideDetailView {
                showRideDetailView.toggle()
            }
            if showPublishedRideView {
                // close current views
                showPublishedRideView.toggle()
            }
            
            if showRideDetailViewFromBooked {
                showRideDetailViewFromBooked.toggle()
            }

            // reset global data
            resetData()
            // call api to fetch latest data for published rides
            sendRequestToGetPublished(httpMethod: .GET, requestType: .publishedRides, data: [:])
            if requestType == .updateRide {
                self.baseViewModel.toastMessageBackground = .green
                baseViewModel.toastMessage = Constants.InfoMessages.rideUpdate
            }
        } else {
            self.baseViewModel.toastMessageBackground = .red
            baseViewModel.toastMessage = Constants.ErrorsMessages.rideUpdate
        }
    }
}
