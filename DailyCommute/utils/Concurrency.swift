//
//  Concurrency.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation

public func main(after seconds: Double = 0.0, closure: @escaping () -> Void) {
    execute(on: DispatchQueue.main, delayInSeconds: seconds, closure: closure)
}

public func async(on queue: DispatchQueue, after seconds: Double = 0.0, closure: @escaping () -> Void) {
    execute(on: queue, delayInSeconds: seconds, closure: closure)
}

public func async(after seconds: Double = 0.0, closure: @escaping () -> Void) {
    execute(on: DispatchQueue.global(qos: .default), delayInSeconds: seconds, closure: closure)
}

public func background(after seconds: Double = 0.0, closure: @escaping () -> Void) {
    execute(on: DispatchQueue.global(qos: .background), delayInSeconds: seconds, closure: closure)
}

private func execute(on queue: DispatchQueue, delayInSeconds: Double, closure: @escaping () -> Void) {
    let milis = Int(delayInSeconds * 1_000)
    queue.asyncAfter(deadline: .now() + .milliseconds(milis), execute: closure)
}
