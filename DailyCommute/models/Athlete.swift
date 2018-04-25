//
//  Athlete.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/19/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Athlete: Strava {
 
    public let id: Int?
    public let firstname: String?
    public let lastname: String?
    public let profileMedium: URL?
    public let profile: URL?
    public let city: String?
    public let state: String?
    public let country: String?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let datePreference: String?
    public let email: String?
    
    required public init(_ json: JSON) {
        id = json["id"].int
        city = json["city"].string
        state = json["state"].string
        country = json["country"].string
        profileMedium = URL(string: json["profile_medium"].string ?? "")
        profile = URL(string: json["profile"].string ?? "")
        firstname = json["firstname"].string
        lastname = json["lastname"].string
        createdAt = json["created_at"].string?.toDate()
        updatedAt = json["updated_at"].string?.toDate()
        datePreference = json["date_preference"].string        
        email = json["email"].string
    }
}
