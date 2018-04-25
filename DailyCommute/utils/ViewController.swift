//
//  ViewController.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

struct ViewController {
    
    static var activityFeedViewController: ActivityFeedViewController {
        return ViewControllerIdentifier.activityFeedViewController.create()
    }
    
    static var newActivityViewController: NewActivityViewController {
        return ViewControllerIdentifier.newActivityViewController.create()
    }
    
    static var signInViewController: SignInViewController {
        return ViewControllerIdentifier.signInViewController.create()
    }
    
}

// MARK: - Other type declarations -

// MARK: ViewControllerIdentifier

private enum ViewControllerIdentifier: String {
    case activityFeedViewController
    case newActivityViewController
    case signInViewController
}

private extension ViewControllerIdentifier {
    
    func create<T: UIViewController>() -> T {
        return UIStoryboard(name: self.storyboardIdentifier.rawValue, bundle: nil).instantiateViewController(withIdentifier: self.rawValue) as! T
    }
    
    private var storyboardIdentifier: StoryboardIdentifier {
        switch self {
        case .activityFeedViewController:
            return .Main
        case .newActivityViewController:
            return .Main
        case .signInViewController:
            return .Main
        }
    }
}

// MARK: Storyboard

private enum StoryboardIdentifier: String {
    case Main
}

// MARK: UIStoryboard

fileprivate extension UIStoryboard {
    
    func initialViewController<T: UIViewController>() -> T {
        return self.instantiateInitialViewController() as! T
    }
    
    func viewControllerWithIdentifier<T: UIViewController>(_ viewControllerIdentifier: ViewControllerIdentifier) -> T {
        return self.instantiateViewController(withIdentifier: viewControllerIdentifier.rawValue) as! T
    }
}
