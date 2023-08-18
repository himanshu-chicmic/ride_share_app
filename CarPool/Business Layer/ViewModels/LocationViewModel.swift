//
//  LocationViewModel.swift
//  CarPool
//
//  Created by Himanshu on 6/26/23.
//

import CoreLocation

class LocationViewModel: NSObject, ObservableObject {

    static let shared = LocationViewModel()
    static let DefaultLocation = CLLocationCoordinate2D(latitude: 45.8827419, longitude: -1.1932383)

    static var currentLocation: String {
        guard let location = shared.locationManager.location else {
            return ""
        }
        let geocoder = CLGeocoder()
        var loc = ""
        geocoder.reverseGeocodeLocation(location) { (placemarks, _) in
            loc = "\(placemarks?.first?.administrativeArea ?? "") \(placemarks?.first?.country ?? "")"
        }
        return loc
    }

    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }

    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager changed the status: \(status)")
    }
}
