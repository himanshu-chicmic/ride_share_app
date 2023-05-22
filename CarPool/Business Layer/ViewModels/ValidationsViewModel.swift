//
//  ValidationsViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation

class ValidationsViewModel: ObservableObject {
    
    // MARK: - properties
    
    static let shared = ValidationsViewModel()
    
    // instance for validations struct
    var validationsInstance = Validations()
    
    // published var for error/validaton messages
    // to be shown on a error dialog box
    @Published var toastMessage: String = ""
    
    // var to know if the screen is processing
    // information and show a progress view
    @Published var inProgess: Bool = false
    
    @Published var naviate: Bool = false
    @Published var dismiss: Bool = false
    
    // navigate boolean
    // navigate to new view if
    // set to true
    @Published var navigateToDashboard: Bool = false
}
