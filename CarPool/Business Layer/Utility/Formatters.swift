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
struct Formatters {
    
    // MARK: - computed properties
    
    // get a date using this format
    static let dateFormatter: DateFormatter = {
        // initialized data formatter class
        let formatter = DateFormatter()
        // set the date format as "yyyy-MM-dd" as stored
        // in constants's placeholder struct as dateOfBirth
        formatter.dateFormat = Constants.Placeholders.dateOfBirth
        // return the formatter
        return formatter
    }()
    
    // get a time using this format
    static let timeFormatter: DateFormatter = {
        // initialized date formatter class
        let formatter = DateFormatter()
        // set the date format as "h:mm a" as stored
        // in constants's placeholder struct as timeFormatter
        formatter.dateFormat = Constants.Placeholders.timeFormatter
        // return the formatter
        return formatter
    }()
    
    // get a time using this format
    static let estimatedTime: DateFormatter = {
        // initialized date formatter class
        let formatter = DateFormatter()
        // set the date format as "HH:mm" as stored
        // in constants's placeholder struct as timeFormatter
        formatter.dateFormat = Constants.Placeholders.estimateTimeFormat
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
    
    // get default maximum date
    static let defaultDateMax: Date = {
        return Calendar.current.date(
            byAdding: .year,
            value   : 1,
            to      : Date()
        )!
    }()
    // get default mininum date
    static let defaultDateMin: Date = {
        return Calendar.current.date(
            byAdding: .year,
            value   : -100,
            to      : Date()
        )!
    }()
    
    // get default dat for date picker
    // set the date back 18 years from today
    static let defaultDateCurrent: Date = {
        return Date.now
    }()
    
    // number formatter for showing years without
    // separating commas ex. (200,1 is shown as 2001)
    private static let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.usesGroupingSeparator = false
        return nf
    }()
    
    // MARK: - properties
    
    // variable to store previous date
    static var previousDate: String = ""

    // MARK: - methods
    
    /// method to get price of the ride in rupee currency
    /// - Parameter price: int value of price
    /// - Returns: a string in currency format
    static func getPrice(price: Int) -> String {
        return String(format: Constants.Placeholders.rupee, price)
    }
    
    /// method to get ratings based on the api response of the ride result
    /// - Parameter ratings: raings in double
    /// - Returns: formatted rating with one decimal point precision
    static func getRatings(ratings: Double) -> String {
        if ratings == 0 {
            return Constants.RideDetails.noRatings
        }
        return "\(String(format: "%.1f", ratings)) ★"
    }
    
    /// method to get distance in kms
    /// - Parameter distance: distance in double
    /// - Returns: a string value of distance in kms
    static func getDistanceInKms(distance: Double) -> String {
        return String(format: "%.2f", (distance*10))
    }
    
    /// method to get date in formate EEEE, MMMM dd YYYY
    /// - Parameter date: date in string format with diffrenet time format
    /// - Returns: date in string formate with required format
    static func getLongDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = Constants.Placeholders.dateOfBirth
        
        guard let dateObj = formatter.date(from: date) else {
            return date
        }
        formatter.dateFormat = Constants.Placeholders.dateFormatterLong
        return formatter.string(from: dateObj)
    }
    
    /// method to check date and return string value for chat data
    /// - Parameter date: date in string format
    /// - Returns: a string value for date
    static func checkDate(date: String) -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = Constants.Placeholders.dateFormat
        
        guard let dateObj = formatter.date(from: date) else {
            return ""
        }
        formatter.timeZone = .current
        formatter.dateFormat = Constants.Placeholders.dateOfBirth
        let currentDate = formatter.string(from: dateObj)
        if previousDate != currentDate {
            previousDate = currentDate
            if currentDate == formatter.string(from: .now) {
                return "Today"
            } else if currentDate == formatter.string(from: Calendar.current.date(
                byAdding: .day,
                value   : -1,
                to      : Date()
            )!) {
                return "Yesterday"
            }
            return currentDate
        }
        return ""
    }
    
    /// method to get estimated time for trip
    /// - Parameter date: estimated time
    /// - Returns: estimated time with only hour and minutes
    static func getEstimatedTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = Constants.Placeholders.dateFormat
        // get date in required format
        guard let dateObj = dateFormatter.date(from: date) else {
            return Constants.RideDetails.estimateTimeUnavailable
        }
        // return estimated time in string format
        dateFormatter.dateFormat = Constants.Placeholders.estimateTimeFormat
        return dateFormatter.string(from: dateObj)
    }
    
    /// method to convert date returned from api result
    /// into hour and minutes format
    /// - Parameter date: date returned from api response
    /// - Returns: a string of time in "h:mm a" format
    static func getFormattedDate(date: String?) -> String {
        guard let date else {
            return Constants.RideDetails.timeUnavailable
        }
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = Constants.Placeholders.dateFormat
        
        // get date in required format
        guard let dateObj = dateFormatter.date(from: date) else {
            return Constants.RideDetails.timeUnavailable
        }
        // return estimated time in string format
        dateFormatter.dateFormat = Constants.Placeholders.timeFormatter
        return dateFormatter.string(from: dateObj)
        
    }
    
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
            years.append(Formatters.yearString(at: year))
        }
        
        // return years array reversed
        // to show most recent years on top
        return years.reversed()
    }
    
    /// method to get text query by replacing whitespaces with `+` sign
    /// used in places search api
    /// - Parameter text: string contaning the query text
    /// - Returns: string with whitespaces replaced with `+`
    static func getTextQueryWithReplacedCharsWithPlus(text: String) -> String {
        return text.replacingOccurrences(of: " ", with: "+")
    }
    
    /// method to convert seconds to time
    /// - Parameter seconds: time in seconds
    /// - Returns: a string value for time
    static func convertSecondsToTime(seconds: Double) -> String {
        let sec = Int(seconds)
        let hh = sec / 3600
        let mm = (sec % 3600) / 60
        let ss = (sec % 3600) % 60
        return "\(hh):\(mm):\(ss)"
    }
}
