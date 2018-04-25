//
//  AppDelegate.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/18/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private static let clientSecret: String = "d7a6d74f8a33b5be22486f0ff4fab247774d47d4"
    
    let strava: StravaService
    lazy var storyboard = { return UIStoryboard(name: "Main", bundle: nil) }()
    
    override init() {
        let config = StravaService.StravaConfig(clientId: 24993, clientSecret: AppDelegate.clientSecret, redirectUri: "dailycommute://localhost")
        strava = StravaService.shared.initWith(config)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.loadInitialViewController()        
        return true
    }
    
    private func loadInitialViewController() {
        let token = UserDefaults.standard.object(forKey: "token") as? String ?? String()
        if token == StravaService.shared.token?.accessToken {
            main(after: 0.3) {
                ViewRoutes.goToRoute(.activityFeed)
            }            
        }
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let code = strava.handleAuthorizationRedirect(url) else { return false }
        NotificationCenter.default.post(name: Notification.Name("code"), object: code)
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
 
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

