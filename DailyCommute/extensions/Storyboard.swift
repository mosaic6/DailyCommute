//
//  Storyboard.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

// MARK: Storyboard

struct Storyboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(storyboardIdentifier: .Main)
    }
    
    static var launch: UIStoryboard {
        return UIStoryboard(storyboardIdentifier: .LaunchScreen)
    }
    
    static var findChap: UIStoryboard {
        return UIStoryboard(storyboardIdentifier: .FindChap)
    }
}

// MARK: StoryboardIdentifier

fileprivate enum StoryboardIdentifier: String {
    case Main
    case LaunchScreen
    case FindChap
}

// MARK: Helpers

fileprivate extension UIStoryboard {
    convenience init(storyboardIdentifier: StoryboardIdentifier) {
        self.init(name: storyboardIdentifier.rawValue, bundle: nil)
    }
}
