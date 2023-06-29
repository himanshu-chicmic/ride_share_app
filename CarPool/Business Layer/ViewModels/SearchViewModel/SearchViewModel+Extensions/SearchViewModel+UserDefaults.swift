//
//  SearchViewModel+UserDefaultsData.swift
//  CarPool
//
//  Created by Himanshu on 6/29/23.
//

import Foundation

extension SearchViewModel {
    
    // MARK: get recentlly viewed data
    
    /// get recent searches and rides history
    /// - Parameter key: key for user defaults
    func getRecentlyViewed(key: String) {
        guard let savedData = UserDefaults.standard.object(forKey: key) as? [Data] else {
            return
        }
        if key == Constants.UserDefaultKeys.recentSearches {
            var recents: [Candidate] = []
            for data in savedData {
                if let jsonData = try? JSONDecoder().decode(Candidate.self, from: data) {
                    recents.append(jsonData)
                }
            }
            self.searchHistory = recents
        } else if key == Constants.UserDefaultKeys.recentViewedRides {
            var recents: [Datum] = []
            for data in savedData {
                if let jsonData = try? JSONDecoder().decode(Datum.self, from: data) {
                    let now = Date.now
                    if let date = Formatters.dateFormatter.date(from: jsonData.publish.date ?? "") {
                        if now < date {
                            recents.append(jsonData)
                        }
                    }
                }
            }
            self.recenltyViewedRides = recents
        }
    }
    
    // MARK: update/set data to user defaults
    
    /// method to update data in user defaults
    /// - Parameters:
    ///   - dataRecentRides: recent rides data
    ///   - dataRecentSearches: recent searches data
    ///   - delete: bool to check for  any deletion call
    func updateRecents(dataRecentRides: Datum? = nil, dataRecentSearches: Candidate? = nil, delete: Bool = false) {
        var recents: [Data] = []
        var encodedData: Data = Data()
        var key: String = Constants.UserDefaultKeys.recentViewedRides
        if let dataRecentRides {
            guard let encoded = try? JSONEncoder().encode(dataRecentRides) else {
                return
            }
            encodedData = encoded
        } else if let dataRecentSearches {
            guard let encoded = try? JSONEncoder().encode(dataRecentSearches) else {
                return
            }
            encodedData = encoded
            key = Constants.UserDefaultKeys.recentSearches
        }
        
        if let data = UserDefaults.standard.object(forKey: key) as? [Data] {
            recents = data
        }
        for data in recents where encodedData == data {
            return
        }
        
        if delete {
            for (index, data) in recents.enumerated() where encodedData == data {
                recents.remove(at: index)
            }
        } else {
            for data in recents where encodedData == data {
                return
            }
            if recents.count >= 5 {
                recents.removeSubrange(4..<recents.count)
            }
            recents.insert(encodedData, at: 0)
        }
        
        UserDefaults.standard.set(recents, forKey: key)
        getRecentlyViewed(key: key)
    }
}
