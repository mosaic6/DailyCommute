//
//  Strava.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/19/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum Scope: String {

    case `public` = "public"
}

public protocol Strava: CustomStringConvertible {
    init(_ json: JSON)
}

extension Strava {
    public var description: String {
        let mirror = Mirror(reflecting: self)
        var desc = ""
        for child in mirror.children {
            desc += "\(child.label!): \(child.value) \n"
        }
        return desc
    }
}
