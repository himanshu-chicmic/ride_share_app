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
    
    // search properties
    
    @Published var startLocation: String = Constants.Placeholders.leavingFrom
    @Published var endLocation: String = Constants.Placeholders.goingTo
    
    @Published var dateOfDeparture: String = Constants.Placeholders.today
    
    @Published var numberOfPersons: String = Constants.Placeholders.one
    
}
