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
        // if request is type of login
        // then get details of the user
        // to get image and other data
        if type == .logIn {
            switchToDashboard = true
            sendRequestToApi(
                httpMethod  : .GET,
                requestType : .getDetails,
                data        : [:]
            )
        }
        else if type == .signUp {
            // if user details is open then close it first
            openUserDetailsView.toggle()
            switchToDashboard = true
        }
        else {
            resetUserDefaults()
            selection = .search
            switchToDashboard = false
        }
    }
    
    /// method to reset user defaults data
    func resetUserDefaults() {
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.session)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.vehiclesData)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.profileData)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.recentSearches)
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKeys.recentViewedRides)
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
        } else {
            switchToDashboard = false
        }
    }
}
