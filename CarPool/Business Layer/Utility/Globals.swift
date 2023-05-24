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
    
    // get default dat for date picker
    // set the date back 18 years from today
    static let defaultDate: Date = {
        return Calendar.current.date(
            byAdding: .year,
            value   : -18,
            to      : Date()
        )!
    }()
    
    // number formatter for showing years without
    // separating commas ex. (200,1 is shown as 2001)
    private static let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.usesGroupingSeparator = false
        return nf
    }()

    // MARK: - methods
    
    /// method to convert int value to year string
    /// - Parameter year: value of year in int
    /// - Returns: value of year in string
    static func yearString(at year: Int) -> String {
        let selectedYear = year
        return numberFormatter.string(for: selectedYear) ?? selectedYear.description
    }
    
    /// method to get years list from 1940 to current year
    /// - Returns: a string array containing years
    static func getYearsList() -> [String] {
        // initialize empty year string array
        var years: [String] = []
        
        // set start year to 1940 (keep it as a constant)
        let start = 1940
        // set current year
        let current = Calendar.current.component(.year, from: Date())
        
        // loop over range start...current
        // and append values to years array
        for year in start...current {
            years.append(Globals.yearString(at: year))
        }
        
        // return years array reversed
        // to show most recent years on top
        return years.reversed()
    }
}
