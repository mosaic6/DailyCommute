//
//  UIAlertController.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/25/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

// MARK: Presenting globally

extension UIAlertController {
    
    func presentInWindow(_ completion: (() -> Void)? = nil) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootViewController = UIViewController()
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        rootViewController.present(self, animated: true, completion: completion)
    }
}

extension UIAlertController {
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle = .alert, actions: [UIAlertAction]) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        for action in actions {
            self.addAction(action)
        }
    }
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle = .alert, buttonTitle: String, completion: (() -> Void)? = nil) {
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        
        self.init(title: title, message: message, preferredStyle: preferredStyle, actions: [action])
    }
}
