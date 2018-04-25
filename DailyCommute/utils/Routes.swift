//
//  Route.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SafariServices

struct ViewRoutes {
    
    enum PresentationStyle: Equatable {
        case presentOnCurrentlyShown
        case presentWithFullScreenShow
        case push(overViewController: UIViewController)
        
        var hashString: String {
            switch self {
            case .presentOnCurrentlyShown:
                return "presentOnCurrentlyShown"
            case .presentWithFullScreenShow:
                return "presentWithFullScreenShow"
            case .push:
                return "push"
            }
        }
        
        static func == (lhs: PresentationStyle, rhs: PresentationStyle) -> Bool {
            return lhs.hashString == rhs.hashString
        }
    }
    
    // MARK: Lifecycle
    
    private init() {}
    
    // MARK: Static Methods
    
    static func goToRoute(_ route: ViewRoutes, presentationStyle: PresentationStyle = .presentOnCurrentlyShown, animated: Bool = true, callback: ((EmptyResult) -> Void)? = nil) {
        
        if ViewRoutes.isDisplaying(route: route) {
            callback?(.failure)
            return
        }
        
        route.createViewController { result in
            switch result {
            case .success(let destination):
                let (preparedViewController, preparedPresentationStyle) = route.prepareViewControllerForPresentation(viewController: destination, presentationStyle: presentationStyle)
                
                switch preparedPresentationStyle {
                case .presentOnCurrentlyShown:
                    UIViewController.presentOnCurrentlyShownViewController(viewController: preparedViewController, animated: animated) {
                        callback?(.success)
                    }
                    
                case .presentWithFullScreenShow:
                    if let fullScreenViewController = preparedViewController as? FullScreenViewController {
                        fullScreenViewController.show { callback?($0) }
                    } else {
                        Log.warn("Attempted to present a non-FullScreenViewController with PresentationStyle.presentWithFullScreenShow")
                    }
                    
                case .push(let viewController):
                    viewController.navigationController?.pushViewController(preparedViewController, animated: animated)
                    callback?(.success)
                }
                
            case .failure:
                callback?(.failure)
                
            }
        }
        
    }
    
    static func isDisplaying(route: ViewRoutes) -> Bool {
        if let currentRoute = UIViewController.currentlyShown as? Routable {
            return currentRoute.isEqual(to: route)
        }
        return false
    }
}

protocol Routable {
    func isEqual(to route: ViewRoutes) -> Bool
}

enum ViewRoutes {
    case newActivity
    case signIn
    
    fileprivate func createViewController(_ callback: @escaping (Result<UIViewController, Empty?>) -> Void) {
        switch self {
        case .newActivity:
            let newActivityViewController = ViewController.newActivityViewController
            callback(.success(newActivityViewController))
        case .signIn:
            let signInViewController = ViewController.signInViewController
            callback(.success(signInViewController))
        }
    }
    
    fileprivate func prepareViewControllerForPresentation(viewController: UIViewController, presentationStyle: ViewRoutes.PresentationStyle) -> (preparedViewController: UIViewController, preparedPresentationStyle: ViewRoutes.PresentationStyle) {
        var preparedViewController = UIViewController.accessControlledDestinationForDestination(viewController)
        
        let preparedPresentationStyle: ViewRoutes.PresentationStyle = preparedViewController == viewController ? presentationStyle : .presentOnCurrentlyShown
        
        
        switch preparedPresentationStyle {
        case .presentOnCurrentlyShown:
            if !(preparedViewController is UINavigationController) {
                preparedViewController = NavigationController(rootViewController: preparedViewController)
            }
            
        case .presentWithFullScreenShow, .push:
            break
        }
        
        if viewController is SFSafariViewController {
            preparedViewController = viewController
        }
        
        return (preparedViewController, preparedPresentationStyle)
    }
}

