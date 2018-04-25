//
//  URL.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/20/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation

extension URL {
    
    func getQueryParameters() -> Dictionary<String, String>? {
        var results = [String:String]()
        let keyValues = self.query?.components(separatedBy: "&")
        keyValues?.forEach {
            let kv = $0.components(separatedBy: "=")
            if kv.count > 1 {
                results[kv[0]] = kv[1]
            }
        }
        return results
    }
}

