//
//  Router.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/19/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public enum Router {
    
    public typealias Id = Int
    public typealias Params = [String: Any]?
    
    case activities(id: Id, params: Params)
    case athlete
    case athleteActivites(params: Params)
    case athletes(id: Id, params: Params)
    case athleteStats(id: Id, params: Params)
    case createActivity(params: Params)
    case routes(id: Id)
    case token(code: String)
    
}

extension Router: URLRequestConvertible {
    
    static var authorizationUrl: URL {
        var url = "https://www.strava.com/oauth/authorize?"
        StravaService.shared.authParams.forEach {
            url.append("\($0)=\($1)&")
        }
        return URL(string: url)!
    }
    
    public func asURLRequest () throws -> URLRequest {
        let config = self.requestConfig
        
        var baseURL: URL {
            switch self {
            case .token:
                return URL(string: "https://www.strava.com/oauth")!
            default:
                return URL(string: "https://www.strava.com/api/v3")!
            }
        }
        
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(config.path))
        urlRequest.httpMethod = config.method.rawValue
        
        if let token = StravaService.shared.token?.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")            
        }
        
        if let params = config.params {
            return try JSONEncoding.default.encode(urlRequest, with: params)
        }
        return try JSONEncoding.default.encode(urlRequest)
    }
}

// MARK: Request Configure

extension Router {
    
    private var requestConfig: (path: String, params: Params, method: Alamofire.HTTPMethod) {
        switch self {
        case .activities(let id, let params):
            return ("/activities/\(id)", params, .get)
        case .athlete:
            return ("/athlete", nil, .get)
        case .athletes(let id, let params):
            return ("/athletes/\(id)", params, .get)
        case .athleteActivites(let params):
            return ("/athlete/activities", params, .get)
        case .athleteStats(let id, let params):
            return ("/athletes/\(id)/stats", params, .get)
        case .createActivity(let params):
            return ("/activities", params, .post)
        case .routes(let id):
            return ("/routes/\(id)", nil, .get)
        case .token(let code):
            return ("/token", StravaService.shared.tokenParams(code), .post)
        }
    }

}
