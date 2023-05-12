//
//  Globals.swift
//  CarPool
//
//  Created by Himanshu on 5/12/23.
//

import Foundation

struct Globals {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
}
