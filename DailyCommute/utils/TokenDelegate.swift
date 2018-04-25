//
//  TokenDelegate.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/19/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation

public protocol TokenDelegate {

    func get() -> OAuthToken?
    func set(_ token: OAuthToken?)
}
