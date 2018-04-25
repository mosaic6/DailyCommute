//
//  UploadData.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SwiftyJSON

public struct UploadData {
    public var activityType: String?
    public var name: String?
    public var description: String?
    public var `private`: Bool?
    public var trainer: Bool?
    public var externalId: String?
    
    public var dataType: DataType
    public var file: Data?
    
    public init(name: String, dataType: DataType, file: Data?) {
        self.name = name
        self.dataType = dataType
        self.file = file
    }
    
    public init(activityType: String?, name: String?, description: String?,
                `private`: Bool?, trainer: Bool?, externalId: String?, dataType: DataType, file: Data?) {
        self.activityType = activityType
        
        self.description = description
        self.`private` = `private`
        self.trainer = trainer
        self.externalId = externalId
        self.name = name
        self.dataType = dataType
        self.file = file
    }
    
    internal var params: [String: Any] {
        
        var params: [String: Any] = [:]
        params["data_type"] = dataType.rawValue
        params["name"] = name
        params["description"] = description
        if let `private` = `private` {
            params["private"] = (`private` as NSNumber).stringValue
        }
        if let trainer = trainer {
            params["trainer"] = (trainer as NSNumber).stringValue
        }
        params["external_id"] = externalId
        return params
    }
    
    /**
     Upload status
     **/
    public final class Status: Strava {
        let id: Int?
        let externalId: String?
        let error: String?
        let status: String?
        let activityId: Int?
        
        public required init(_ json: JSON) {
            id = json["id"].int
            externalId = json["external_id"].string
            error = json["error"].string
            status = json["status"].string
            activityId = json["activity_id"].int
        }
    }
}
