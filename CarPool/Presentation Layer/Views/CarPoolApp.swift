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
    
    // MARK: - body
    
    var body: some Scene {
        WindowGroup {
            Group {
                if baseViewModel.switchToDashboard {
                    DashboardView()
                } else {
                    ContentView()
                }
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
