//
//  UserDetailsViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation
import SwiftUI

class UserDetailsViewModel: ObservableObject {
    
    // MARK: - properties
    
    // picker variables
    @Published var showDatePicker = false
    @Published var showGenderPicker = false
    @Published var showCountryPicker = false
    @Published var showColorPicker = false
    @Published var showYearPicker = false
    
    // variable to store date
    // set the default date by
    // difference of 18 years from now
    @Published var date: Date = Globals.defaultDate
    // variable to store gender
    @Published var gender: String = Constants.Placeholders.selectGender
    
    @Published var country: String = Constants.Vehicle.country
    @Published var color: String = Constants.Vehicle.color
    @Published var year: String = Constants.Vehicle.modelYear
    
    // MARK: - methods
    
    /// method to reset properties
    /// associated with date and gender pickers
    func resetPickerData() {
        showDatePicker = false
        showGenderPicker = false
        date = Date.now
        gender = Constants.Placeholders.selectGender
    }
    
    /// method to show/hide gender picker
    /// - Parameter show: boolean value, show when true and hide when false
    func showHideGenderPicker(show: Bool) {
        withAnimation {
            showGenderPicker = show
        }
    }
    
    /// method to show/hide date picker
    /// - Parameter show: boolean value, show when true and hide when false
    func showHideDatePicker(show: Bool) {
        withAnimation {
            showDatePicker = show
        }
    }
    
}
