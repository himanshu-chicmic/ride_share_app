//
//  VehicleModel.swift
//  CarPool
//
//  Created by Nitin on 5/22/23.
//

import Foundation
import UIKit

struct VehicleModel {
    
    // MARK: - properties
    
    var number: String
    var brand: String
    var name: String
    var type: String
    
    // MARK: - initializers
    
    /// default initializer to assign values to properties
    init() {
        self.number = ""
        self.brand = ""
        self.name = ""
        self.type = ""
    }
    
    // MARK: - methods
    
    func getInputFields() -> Constants.TypeAliases.InputFieldArrayType {
        
        // return the array with necessary
        // values of input fields
        return [
            (
                "",
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
                "",
                Constants.Vehicle.color,
                InputFieldIdentifier.color,
                UIKeyboardType.default
            ),
            (
                "",
                Constants.Vehicle.modelYear,
                InputFieldIdentifier.model,
                UIKeyboardType.default
            )
        ]
        
    }
}
