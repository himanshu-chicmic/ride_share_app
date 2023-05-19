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
    
    // state object of validations view model
    @StateObject var validationsViewModel = ValidationsViewModel()
    @StateObject var userDetailsViewModel = UserDetailsViewModel()
    
    // MARK: - body
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                // set validationViewModel and userDetailsViewModel
                // in environment object for later use
                .environmentObject(validationsViewModel)
                .environmentObject(userDetailsViewModel)
        }
    }
}
