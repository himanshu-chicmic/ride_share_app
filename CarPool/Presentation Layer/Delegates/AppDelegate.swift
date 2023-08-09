//
//  AppDelegate.swift
//  CarPool
//
//  Created by Himanshu on 6/28/23.
//

import GoogleMaps
import GooglePlaces

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Helpers.fetchAPIKey())
        GMSPlacesClient.provideAPIKey(Helpers.fetchAPIKey())
         return true
     }
}
