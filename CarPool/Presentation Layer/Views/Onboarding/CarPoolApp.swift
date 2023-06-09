//
//  CarPoolApp.swift
//  CarPool
//
//  Created by Himanshu on 5/10/23.
//

import SwiftUI

@main
struct CarPoolApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // MARK: - properties
    // view models
    @StateObject var baseViewModel = BaseViewModel.shared
    @StateObject var detailsViewModel = DetailsViewModel()
    
    // state variables
    @State var toggleDashboardContentView: Bool = false
    
    // MARK: - body
    
    var body: some Scene {
        WindowGroup {
            Group {
                if toggleDashboardContentView {
                    DashboardView()
                } else {
                    OnboardingView()
                }
            }
            .onChange(of: baseViewModel.switchToDashboard) { value in
                toggleDashboardContentView = value
            }
            .environmentObject(baseViewModel)
            .environmentObject(detailsViewModel)
            .onAppear {
                baseViewModel.switchDashboardLogin()
            }
            .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
        }
    }
}
