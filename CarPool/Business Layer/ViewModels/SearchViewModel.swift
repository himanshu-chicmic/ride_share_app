//
//  SearchViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/18/23.
//

import Foundation

/// view model for search properties and methods
class SearchViewModel: ObservableObject {
    
    // MARK: - properties
    
    // MARK: published properties
    @Published var startLocation: String = ""
    @Published var endLocation: String = ""
    
    @Published var dateOfDeparture: Date = Globals.defaultDateCurrent
    
    @Published var numberOfPersons: String = Constants.Placeholders.one
    
    @Published var activeSearchView: Bool = false
    @Published var searchComponentType: SearchInputsIdentifier = .numberOfPersons
    
    @Published var showSearchResults: Bool = false
    
    var baseViewModel = BaseViewModel.shared
    
    // MARK: - method
    
    // MARK: utility method
    func validateSearchInput() {
//        if startLocation.isEmpty {
//            baseViewModel.toastMessage = "Enter a start location"
//        } else if endLocation.isEmpty {
//            baseViewModel.toastMessage = "Enter an end location"
//        } else {
            showSearchResults.toggle()
//        }
    }
}
