//
//  LocationViewModel.swift
//  CarPool
//
//  Created by Himanshu on 6/26/23.
//

import Foundation
import CoreLocation
import MapKit

class LocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // MARK: - properties
    
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: String = ""
    
    private let locationManager: CLLocationManager
    
    // MARK: - initializers
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - methods
    
    func checkPermissionAndGetLocation() {
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            startLocationUpdation()
        default:
            requestPermission()
        }
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    
    func startLocationUpdation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func stopLocationUpdation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        fetchCountryAndCity(for: locations.first)
    }

    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, _) in
            self.currentLocation = "\(placemarks?.first?.administrativeArea ?? "") \(placemarks?.first?.country ?? "")"
        }
    }
}
