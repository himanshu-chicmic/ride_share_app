//
//  VehicleModel.swift
//  CarPool
//
//  Created by Himanshu on 5/22/23.
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
    
    func getInputFields(data: VehiclesDataClass?) -> Constants.TypeAliases.InputFieldArrayType {
        
        // return the array with necessary
        // values of input fields
        return [
            (
                data?.vehicleNumber ?? number,
                Constants.Vehicle.number,
                InputFieldIdentifier.vehicleNumber,
                UIKeyboardType.default
            ),
            (
                data?.vehicleBrand ?? brand,
                Constants.Vehicle.brand,
                InputFieldIdentifier.vehicleBrand,
                UIKeyboardType.default
            ),
            (
                data?.vehicleName ?? name,
                Constants.Vehicle.name,
                InputFieldIdentifier.vehicleName,
                UIKeyboardType.default
            ),
            (
                data?.vehicleType ?? type,
                Constants.Vehicle.type,
                InputFieldIdentifier.vehicleType,
                UIKeyboardType.default
            ),
            (
                data?.vehicleColor ?? "",
                Constants.Vehicle.color,
                InputFieldIdentifier.vehicleColor,
                UIKeyboardType.default
            ),
            (
                Globals.yearString(at: data?.vehicleModelYear ?? 0),
                Constants.Vehicle.modelYear,
                InputFieldIdentifier.vehicleModelYear,
                UIKeyboardType.default
            )
        ]
        
    }
}
