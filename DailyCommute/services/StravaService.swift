//
//  ActivityService.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/18/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SafariServices

open class StravaService {
    
    private static let stravaAuthUrl: String = "https://www.strava.com/oauth/authorize"
    
    private init() {}
    static let shared = StravaService()
    
    // MARK: Variables
    
    private var currentViewController : UIViewController? { return UIApplication.shared.keyWindow?.rootViewController }
    private var config: StravaConfig?
    
    internal var safariViewController: SFSafariViewController?
    internal var authParams: [String: Any] {
        return [
            "client_id" : config?.clientId ?? 0,
            "redirect_uri" : config?.redirectUri ?? "",
            "state" : "ios" as AnyObject,
            "scope" : "write,view_private",
            "approval_prompt": "auto",
            "response_type" : "code"
        ]
    }
    internal func tokenParams(_ code: String) -> [String: Any]  {
        return [
            "client_id" : config?.clientId ?? 0,
            "client_secret" : config?.clientSecret ?? "",
            "code" : code
        ]
    }
    
    open var token: OAuthToken? { return config?.delegate.get() }
    
    // MARK: Initialize
    
    public func initWith(_ config: StravaService.StravaConfig) -> StravaService {
        self.config = config
        
        return self
    }
    
    
    // MARK: Auth
    
    func authorizeStrava(sender: UIViewController? = nil) {
        safariViewController = SFSafariViewController(url: Router.authorizationUrl)
        if let safariViewController = safariViewController {
            (sender ?? currentViewController)?.present(safariViewController, animated: true, completion: nil)
        }

    }
    
    // MARK: Handle Redirect
    
    public func handleAuthorizationRedirect(_ url: URL) -> String?  {
        safariViewController?.dismiss(animated: true, completion: nil)
        safariViewController = nil
        return url.getQueryParameters()?["code"]
    }
    
    // MARK: Get OAuth Token
    
    public func getAccessToken(_ code: String, result: @escaping (((OAuthToken)?) -> Void)) throws {
        try oauthRequest(Router.token(code: code))?.responseStrava { [weak self] (response: DataResponse<OAuthToken>) in
            guard let strongSelf = self else { return }
            let token = response.result.value
            strongSelf.config?.delegate.set(token)
            UserDefaults.standard.set(token?.accessToken, forKey: "token")
            UserDefaults.standard.synchronize()
            result(token)
        }
    }
    
    fileprivate func isConfigured() -> (Bool, Error?) {
        if config == nil {
            return (false, nil)
        }
        
        return (true, nil)
    }
    
    fileprivate func checkConfiguration() {
        let (_, error) = StravaService.shared.isConfigured()
        
        if let _ = error {
            fatalError("Strava client is not configured")
        }
    }
    
    fileprivate func oauthRequest(_ urlRequest: URLRequestConvertible) throws -> DataRequest? {
        checkConfiguration()
        
        return Alamofire.request(urlRequest)
    }
    
    fileprivate func oauthUpload<T: Strava>(URLRequest: URLRequestConvertible, upload: UploadData, completion: @escaping (DataResponse<T>) -> ()) {
        checkConfiguration()
        
        guard let url = try? URLRequest.asURLRequest() else { return }
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append((upload.file ?? nil)!, withName: "\(upload.name ?? "default").\(upload.dataType)")
            for (key, value) in upload.params {
                if let value = value as? String {
                    multipartFormData.append(value.data(using: .utf8)!, withName: key)
                }
            }
        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, with: url) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseStrava { (response: DataResponse<T>) in
                    completion(response)
                }
            case .failure(let encodingError):
                print(encodingError)
            }
        }
    }
    
}

//MARK: - Athlete

extension StravaService {
    
    public func upload<T: Strava>(_ route: Router, upload: UploadData, result: @escaping (((T)?) -> Void), failure: @escaping (NSError) -> Void) {
        do {
            try oauthUpload(URLRequest: route.asURLRequest(), upload: upload) { (response: DataResponse<T>) in
                if let statusCode = response.response?.statusCode, (400..<500).contains(statusCode) {
                    failure(self.generateError(failureReason: "Strava API Error", response: response.response))
                } else {
                    result(response.result.value)
                }
                result(response.result.value)
            }
        } catch let error as NSError {
            failure(error)
        }
    }

    public func request<T: Strava>(_ route: Router, result: @escaping (((T)?) -> Void), failure: @escaping (NSError) -> Void) throws {
        do {
            try oauthRequest(route)?.responseStrava { (response: DataResponse<T>) in
                // HTTP Status codes above 400 are errors
                if let statusCode = response.response?.statusCode, (400..<500).contains(statusCode) {
                    failure(self.generateError(failureReason: "Strava API Error", response: response.response))
                } else {
                    result(response.result.value)
                }
            }
        } catch let error as NSError {
            failure(error)
        }
    }
    
    public func requestMulti<T: Strava>(_ route: Router, result: @escaping ((([T])?) -> Void), failure: @escaping (NSError) -> Void) throws {
        do {
            try oauthRequest(route)?.responseStravaArray { (response: DataResponse<[T]>) in
                if let statusCode = response.response?.statusCode, (400..<500).contains(statusCode) {
                    failure(self.generateError(failureReason: "Strava API Error", response: response.response))
                } else {
                    result(response.result.value)
                }
            }
        } catch let error as NSError {
            failure(error)
        }
    }
    
    fileprivate func generateError(failureReason: String, response: HTTPURLResponse?) -> NSError {
        let errorDomain = "com.stravaswift.error"
        let userInfo = [NSLocalizedFailureReasonErrorKey: failureReason]
        let code = response?.statusCode ?? 0
        let returnError = NSError(domain: errorDomain, code: code, userInfo: userInfo)
        
        return returnError
    }
    
}

// MARK: Configure

extension StravaService {
    
    public struct StravaConfig {
        
        public let clientId: Int
        public let clientSecret: String
        public let redirectUri: String
        public let delegate: TokenDelegate
        
        
        public init(clientId: Int, clientSecret: String, redirectUri: String, delegate: TokenDelegate? = nil) {
            self.clientId = clientId
            self.clientSecret = clientSecret
            self.redirectUri = redirectUri
            self.delegate = delegate ?? DefaultTokenDelegate()
        }
    }
}
