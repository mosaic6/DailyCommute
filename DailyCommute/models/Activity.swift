//
//  Activity.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SwiftyJSON

public final class Activity: Strava {
    
    public typealias Speed = Double
    public typealias Count = Int
    
    public let id: Int?
    public let externalId: String?
    public let uploadId: Int?
    public let athlete: Athlete?
    public let name: String?
    public let description: String?
    public let distance: Double?
    public let movingTime: TimeInterval?
    public let elapsedTime: TimeInterval?
    public let type: String?
    public let startDate: Date?
    public let startLatLng: Location?
    public let endLatLng: Location?
    public let commute: Bool?
    public let averageSpeed: Speed?
    
    required public init(_ json: JSON) {
        
        id = json["id"].int        
        externalId = json["external_id"].string
        uploadId = json["upload_id"].int
        athlete = json["athlete"].strava(Athlete.self)
        name = json["name"].string
        description = json["description"].string
        distance = json["distance"].double
        movingTime = json["moving_time"].double
        elapsedTime = json["elapsed_time"].double
        type = json["type"].string
        startDate = json["start_date"].string?.toDate()
        startLatLng = json["start_latlng"].strava(Location.self)
        endLatLng = json["end_latlng"].strava(Location.self)
        commute = json["commute"].bool
        averageSpeed = json["average_speed"].double
    }
}

public struct Location: Strava {
    let lat: Double?
    let lng: Double?

    public init(_ json: JSON) {
        let points = json.arrayValue
        self.lat = points.first?.double
        self.lng = points.last?.double
    }
}
