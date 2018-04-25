//
//  OAuthToken.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/19/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct OAuthToken: Strava {
    
    public let accessToken: String?
    public let athlete: Athlete?
    
    public init(_ json: JSON) {
        accessToken = json["access_token"].string
        athlete = Athlete(json["athlete"])
    }
}
