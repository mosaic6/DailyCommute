//
//  DefaultTokenDelegate.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/20/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation

open class DefaultTokenDelegate: TokenDelegate {
    
    fileprivate var token: OAuthToken?
    
    open func get() -> OAuthToken? {
        return token
    }
    
    open func set(_ token: OAuthToken?) {
        self.token = token
    }
}
