//
//  ViewController.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/18/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController {
    
    // MARK: Variables
    
    var authCode: String?
    
    private var authToken: OAuthToken?
    private var strava = StravaService.shared
    
    // MARK: IBOutlets
    
    @IBOutlet weak var signInButton: UIButton?
    
    // MARK: Lifecycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNotificationObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.configureSignInButton()
    }
}

// MARK: Configure

private extension SignInViewController {
    
    func configureSignInButton() {
        self.signInButton?.layer.cornerRadius = 3.0
    }
}

// MARK: IBActions

private extension SignInViewController {
    
    @IBAction func connectWithStravaButtonTapped(_ sender: Any) {
        self.strava.authorizeStrava(sender: self)
    }
}

// MARK: Notification Center

private extension SignInViewController {
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(SignInViewController.authenticateUser), name: Notification.Name("code"), object: nil)
    }
    
    @objc func authenticateUser(_ notification: Notification) {
        guard let code = notification.object as? String else { return }
        
        try? strava.getAccessToken(code) { [weak self] token in
            if let strongSelf = self, let token = token {
                strongSelf.authToken = token
                main(after: 0.3) {
                    ViewRoutes.goToRoute(.activityFeed)
                }
            } else {
                AlertView.errorNoRetry("There was an issue signing you in. Please try again.")
            }
        }
    }
}
