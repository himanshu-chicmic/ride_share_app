//
//  Globals.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import Foundation
import SwiftUI

/// this struct contains globally used
/// utility methods or properties
struct Globals {
    
    // get a date in using this format
    static let dateFormatter: DateFormatter = {
        // initialized data formatter class
        let formatter = DateFormatter()
        // set the date format as "dd/MM/yyyy" as stored
        // in constants's placeholder struct as dateOfBirth
        formatter.dateFormat = Constants.Placeholders.dateOfBirth
        // return the formatter
        return formatter
    }()
    
    static let defaultDate: Date = {
        return Calendar.current.date(
            byAdding: .year,
            value   : -18,
            to      : Date()
        )!
    }()
    
    private static let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.usesGroupingSeparator = false
        return nf
    }()

    static func yearString(at index: Int) -> String {
        let selectedYear = index
        return numberFormatter.string(for: selectedYear) ?? selectedYear.description
    }
    
    static func getYearsList() -> [String] {
        
        var years: [String] = []
        
        let start = 1940
        let current = Calendar.current.component(.year, from: Date())
        for year in start...current {
            years.append(Globals.yearString(at: year))
        }
        
        return years.reversed()
    }
}
