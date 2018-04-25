//
//  CallbackResult.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation

import Foundation

public enum CallbackResult<T, U> {
    public typealias SuccessType = T
    public typealias FailureType = U
    
    case success(SuccessType)
    case failure(FailureType)
}

public enum EmptyResult {
    case success
    case failure
}

public enum StandardResult {
    case success
    case failure(String?)
}

public class Empty { }
