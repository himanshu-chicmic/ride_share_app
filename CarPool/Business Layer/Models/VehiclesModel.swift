//
//  VehiclesModel.swift
//  CarPool
//
//  Created by Nitin on 5/22/23.
//

import Foundation
import UIKit

struct VehiclesModel {
    
    // MARK: - properties
    
    var country: String
    var number: String
    var brand: String
    var name: String
    var type: String
    var color: String
    var modelYear: String
    
    // MARK: - initializers
    
    init() {
        self.country = ""
        self.number = ""
        self.brand = ""
        self.name = ""
        self.type = ""
        self.color = ""
        self.modelYear = ""
    }
    
    // MARK: - methods
    
    func getInputFields() -> Constants.TypeAliases.InputFieldArrayType {
        
        // return the array with necessary
        // values of input fields
        return [
            (
                country,
                Constants.Vehicle.country,
                InputFieldIdentifier.country,
                UIKeyboardType.default
            ),
            (
                number,
                Constants.Vehicle.number,
                InputFieldIdentifier.text,
                UIKeyboardType.default
            ),
            (
                brand,
                Constants.Vehicle.brand,
                InputFieldIdentifier.text,
                UIKeyboardType.default
            ),
            (
                name,
                Constants.Vehicle.name,
                InputFieldIdentifier.text,
                UIKeyboardType.default
            ),
            (
                type,
                Constants.Vehicle.type,
                InputFieldIdentifier.text,
                UIKeyboardType.default
            ),
            (
                color,
                Constants.Vehicle.color,
                InputFieldIdentifier.color,
                UIKeyboardType.default
            ),
            (
                modelYear,
                Constants.Vehicle.modelYear,
                InputFieldIdentifier.model,
                UIKeyboardType.default
            )
        ]
        
    }
}
