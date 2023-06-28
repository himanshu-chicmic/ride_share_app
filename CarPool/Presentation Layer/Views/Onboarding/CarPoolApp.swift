//
//  CarPoolApp.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI
import GoogleMaps
import GooglePlaces

@main
struct CarPoolApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // MARK: - properties
    // state object of view models
    @StateObject var baseViewModel = BaseViewModel.shared
    @StateObject var detailsViewModel = DetailsViewModel()
    
    // state variable to change the views
    @State var toggleDashboardContentView: Bool = false
    
    // MARK: - body
    
    var body: some Scene {
        WindowGroup {
            Group {
                // if toggleDashboardContentView is set to true
                // then show dashboard else show onboarding
                if toggleDashboardContentView {
                    DashboardView()
                } else {
                    OnboardingView()
                }
            }
            .onChange(of: baseViewModel.switchToDashboard) { value in
                toggleDashboardContentView = value
            }
            // set baseViewModel and detailsViewModel
            // in environment object for later use
            .environmentObject(baseViewModel)
            .environmentObject(detailsViewModel)
            .onAppear {
                baseViewModel.switchDashboardLogin()
            }
            .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(Globals.fetchAPIKey())
        GMSPlacesClient.provideAPIKey(Globals.fetchAPIKey())
         return true
     }
}
