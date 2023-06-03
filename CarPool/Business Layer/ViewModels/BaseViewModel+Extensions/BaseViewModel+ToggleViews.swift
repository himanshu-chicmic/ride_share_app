//
//  BaseViewModel+ToggleViews.swift
//  CarPool
//
//  Created by Himanshu on 6/3/23.
//

import Foundation
import SwiftUI

extension BaseViewModel {
    
    // MARK: methods for view components
    /// method to handle reponse for login, signup and logout
    /// - Parameter response: response returned from api call
    func switchDashboardOnboarding(response: SignInAndProfileModel, type: RequestType) {
        // if user details is open then close it first
        if openUserDetailsView {
            openUserDetailsView.toggle()
        }
        // then toggle switch to dashboard
        switchToDashboard.toggle()
    }
    
    /// method to dismiss toast message by
    /// setting it's value to empyt in three seconds
    /// from the time it's been set with a message
    func dismissToastInThreeSeconds() {
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.toastMessage = ""
            }
        }
    }
    
    /// method to disable progress bar state
    func disableProgress() {
        // set in progress to false for hiding loader - on response received
        inProgess = false
    }
    
    /// change navigation stack for tab bar view or login methods
    func switchDashboardLogin() {
        // get session authorization token from user defaults
        if let token = UserDefaults.standard.value(forKey: Constants.UserDefaultKeys.session) as? String {
            // return false if not found
            switchToDashboard = !token.isEmpty
        }
    }
}
