//
//  Array.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/22/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation

extension Array {
    
    public subscript(safe index: Int) -> Element? {
        get {
            return index >= 0 && index < self.count ? self[index] : nil
        }
        set {
            if let newValue = newValue, index >= 0, index < self.count {
                self[index] = newValue
            }
        }
    }
}
