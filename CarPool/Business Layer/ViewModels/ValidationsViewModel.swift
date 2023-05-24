//
//  ValidationsViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI

class ValidationsViewModel: ObservableObject {
    
    // MARK: - properties
    
    // shared instance of validations view model
    static let shared = ValidationsViewModel()
    
    // instance for validations struct
    var validationsInstance = Validations()
    
    // published var for error/validaton messages
    // to be shown on a error dialog box
    @Published var toastMessage: String = "" {
        // did set property
        // observers any changes in toastMessage property
        didSet {
            // if toast message is not empyt
            if !toastMessage.isEmpty {
                // call dismiss method for toast
                dismissToastInThreeSeconds()
            }
        }
    }
    
    // var to know if the screen is processing
    // information and show a progress view
    @Published var inProgess: Bool = false
    
    // navigate or dismiss variables
    @Published var navigate: Bool = false
    @Published var dismiss: Bool = false
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @Published var navigateToDashboard: Bool = false
    
    // open view for user detials
    @Published var openUserDetailsView: Bool = false
    
    // check logged in status
    // to let the view switch
    // between dashboard or content view
    var loggedInStatus: Bool {
        // get session authorization token from user defaults
        guard let token = UserDefaults.standard.value(forKey: "SessionAuthToken") as? String else {
            // return false if not found
            return false
        }
        
        // return false in empty
        if token.isEmpty {
            return false
        }
        
        // return true if found
        return true
    }
    
    // MARK: - methods
    
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
    
    /// method to navigate to dashboard view
    func goToDashboard() {
        // disable progress
        disableProgress()
        // toggle navigate to dashboard
        // changing this will activate is presented
        // inside view and navigate to dashboard
        navigateToDashboard.toggle()
    }
    
    /// method to open user details view
    func goToUserDetails() {
        // disable progress
        disableProgress()
        // toggle open user details
        // changing this will activate is presented
        // inside view and open user details view
        openUserDetailsView.toggle()
    }
}
