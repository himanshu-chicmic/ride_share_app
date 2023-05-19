//
//  ValidationsViewModel.swift
//  CarPool
//
//  Created by Himanshu on 5/19/23.
//

import Foundation

class ValidationsViewModel: ObservableObject {
    
    // MARK: - properties
    
    // instance for validations struct
    var validationsInstance = Validations()
    
    // published var for error/validaton messages
    // to be shown on a error dialog box
    @Published var toastMessage: String = ""
}
