//
//  JSON.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SwiftyJSON

extension RawRepresentable {
    init?(o rawValue: RawValue?) {
        guard let rawValue = rawValue, let value = Self(rawValue: rawValue) else { return nil }
        self = value
    }
}

extension JSON  {
    public func strava<T: Strava>(_ type: T.Type?) -> T? {
        return type?.init(self)
    }
    
    public func strava<T: RawRepresentable>(_ type: T.Type?) -> T? where T.RawValue == Int {
        return type?.init(rawValue: self.int!)
    }
    
    public func strava<T: RawRepresentable>(_ type: T.Type?) -> T? where T.RawValue == String {
        return type?.init(rawValue: self.string!)
    }
    
    public func strava<T: Strava>(_ type: T.Type?) -> [T]? {
        return self.arrayValue.compactMap  { T($0) }
    }
    
}
