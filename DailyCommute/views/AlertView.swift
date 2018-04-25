//
//  AlertView.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/25/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    
    class func errorNoRetry(_ message: String?, dismissed: (() -> Void)? = nil) {
        guard let message = message else {
            return
        }
        
        AlertView.error(message, cancel: dismissed, retry: nil)
    }
    
    private class func error(_ message: String, cancel: (() -> Void)?, retry: (() -> Void)?) {
        let cancelButtonTitle = retry != nil ? "Cancel" : "Ok"
        
        var actions: [UIAlertAction] = [
            UIAlertAction(title: cancelButtonTitle, style: retry == nil ? .default : .cancel) { _ in
                cancel?()
            }
        ]
        
        if let retry = retry {
            actions.append(UIAlertAction(title: "Try Again", style: .default) { _ in
                retry()
            })
        }
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert, actions: actions)        
        alertController.presentInWindow()
    }
}
