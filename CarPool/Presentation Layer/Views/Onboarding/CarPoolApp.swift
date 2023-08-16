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
    
    @State var showSplash = true
    
    // MARK: - body
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView()
                } else {
                    if baseViewModel.switchToDashboard {
                        DashboardView()
                    } else {
                        OnboardingView()
                    }
                }
            }
            .environmentObject(baseViewModel)
            .environmentObject(detailsViewModel)
            .onAppear {
                baseViewModel.switchDashboardLogin()
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
            .accentColor(Color(uiColor: UIColor(hexString: Constants.DefaultColors.primary)))
        }
    }
}
