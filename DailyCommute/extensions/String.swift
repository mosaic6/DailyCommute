//
//  File.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/19/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation

extension String {
    
    func toDate(_ format: String = "yyyy-MM-dd'T'HH:mm:ssZZZZZ") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
