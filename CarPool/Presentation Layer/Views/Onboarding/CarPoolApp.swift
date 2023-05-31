//
//  CarPoolApp.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

@main
struct CarPoolApp: App {

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
        }
    }
}
