//
//  SearchViewModel+Utility.swift
//  CarPool
//
//  Created by Himanshu on 6/29/23.
//

import Foundation

extension SearchViewModel {
    
    // MARK: - utility methods
    
    // MARK: methods related to properties
    
    /// reset loaded data
    func resetArrayData() {
        suggestions = []
        searchHistory = []
        searchResults = []
        recenltyViewedRides = []
        publishedRidesData = []
        bookedRidesData = []
    }
    
    /// reset all input fields
    func resetData() {
        self.startLocation = ""
        self.endLocation = ""
        self.dateOfDeparture = Formatters.defaultDateCurrent
        self.numberOfPersons = Constants.Placeholders.one
        self.selectedVehicle = ""
        self.selectedVehicleId = 0
        self.pricePerSeat = ""
    }
    
    /// method to ensure that start and end location doen't
    /// mix up and provide wrong results
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
    
    // MARK: methods for validations
    
    /// method to validate search input fields
    func validateInputFields() {
        baseViewModel.toastMessageBackground = .red
        if startLocation.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.emptyStartLocation
        } else if endLocation.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.emptyEndLocation
        } else if !findRide && selectedVehicle.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.pleaseSelectVehicle
        } else if !findRide && pricePerSeat.isEmpty {
            baseViewModel.toastMessage = Constants.ValidationMessages.pleaseSetPrice
        } else if !findRide && pricePerSeat.range(
            of: Constants.ValidationRegex.price,
            options: .regularExpression) == nil {
            baseViewModel.toastMessage = Constants.ValidationMessages.invalidPrice
        }
    }
    
    /// method used to call api
    func callApiMethods() {
        validateInputFields()
        if baseViewModel.toastMessage.isEmpty, let startLocationVal, let endLocationVal {
            if findRide {
                let data : [String : Any] = [
                    Constants.JsonKeys.sourceLongitude      : startLocationVal.geometry.location.lng,
                    Constants.JsonKeys.sourceLatitude       : startLocationVal.geometry.location.lat,
                    Constants.JsonKeys.destinationLongitude : endLocationVal.geometry.location.lng,
                    Constants.JsonKeys.destinationLatitude  : endLocationVal.geometry.location.lat,
                    Constants.JsonKeys.passengersCount      : numberOfPersons,
                    Constants.JsonKeys.date                 : Formatters.dateFormatter.string(from: dateOfDeparture)
                ]
                sendRequestForSearchAndPublish(httpMethod: .GET, requestType: .searchRides, data: data)
            } else {
                if baseViewModel.toastMessage.isEmpty {
                    openMapView.toggle()
                }
            }
        }
    }
    
    /// method to call api for publishing a ride
    func callApiForPublish() {
        if let startLocationVal, let endLocationVal, let price = Double(pricePerSeat), let persons = Int(numberOfPersons) {
            let data : [String : Any] = [
                Constants.JsonKeys.source               : startLocationVal.formattedAddress,
                Constants.JsonKeys.destination          : endLocationVal.formattedAddress,
                Constants.JsonKeys.sourceLongitude      : startLocationVal.geometry.location.lng,
                Constants.JsonKeys.sourceLatitude       : startLocationVal.geometry.location.lat,
                Constants.JsonKeys.destinationLongitude : endLocationVal.geometry.location.lng,
                Constants.JsonKeys.destinationLatitude  : endLocationVal.geometry.location.lat,
                Constants.JsonKeys.passengersCount      : persons,
                Constants.JsonKeys.date                 : Formatters.dateFormatter.string(from: dateOfDeparture),
                Constants.JsonKeys.time                 : Formatters.timeFormatter.string(from: dateOfDeparture),
                Constants.JsonKeys.setPrice             : price,
                Constants.JsonKeys.aboutRide            : "",
                Constants.JsonKeys.vehicleId            : selectedVehicleId,
                Constants.JsonKeys.bookInstantly        : true,
                Constants.JsonKeys.midSeat              : false,
                Constants.JsonKeys.estimateTime         : estimatedTime,
                Constants.JsonKeys.selectRoute          : []
            ]
            sendRequestForSearchAndPublish(httpMethod: .POST, requestType: .publishedRides, data: [Constants.JsonKeys.publish : data])
        }
        
    }
    
    /// method to update recetly viewed rides and  call api
    ///  to get vehicle data when clicked on search item
    /// - Parameter data: data for rides
    func searchItemClicked<T: Any>(data: T) {
        var vehicleId: Int?
        
        if let data = data as? Datum {
            vehicleId = data.publish.vehicleID!
            showRideDetailView.toggle()
            updateRecents(dataRecentRides: data)

        }
        
        if let data = data as? BookedRidesData {
            showRideDetailViewFromBooked.toggle()
            vehicleId = data.ride.vehicleID!
        }
        
        if let data = data as? Publish {
            vehicleId = data.vehicleID!
            let publishId = data.id
            sendRequestToGetPublishedByID(httpMethod: .GET, requestType: .publishedRideById, data: [Constants.JsonKeys.id: publishId])
        }
        
        baseViewModel.sendVehiclesRequestToApi(
                httpMethod: .GET, requestType: .getVehicleById, data: [Constants.JsonKeys.id: vehicleId!]
        )
    }
    
    /// method to swap start and end location in search view's text fields
    func swapStartEndLocation() {
        let temp = startLocation
        startLocation = endLocation
        endLocation = temp
    }
}
