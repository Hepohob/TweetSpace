//
//  History.swift
//  Smashtag
//
//  Created by Aleksei Neronov on 27.12.16.
//  Copyright © 2016 Aleksei Neronov. All rights reserved.
//

import Foundation

struct History {
    private static let defaults = UserDefaults.standard
    private static let key = "History"
    private static let limit = 100
    
    static var searches: [String] {
        return (defaults.object(forKey: key) as? [String]) ?? []
    }
    
    static func add(_ term: String) {
        var newArray = searches.filter({ term.caseInsensitiveCompare($0) != .orderedSame })
        newArray.insert(term, at: 0)
        while newArray.count > limit {
            newArray.removeLast()
        }
        defaults.set(newArray, forKey:key)
    }
    
    static func removeAtIndex(_ index: Int) {
        var currentSearches = (defaults.object(forKey: key) as? [String]) ?? []
        currentSearches.remove(at: index)
        defaults.set(currentSearches, forKey:key)
    }
}
