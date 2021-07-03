//
//  AppDelegate.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: Screen.bounds)
        appCoordinator = AppCoordinator(window: window!)
        appCoordinator?.start()

        return true
    }

}

extension AppDelegate {

    static var shared: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

}

extension UIApplication {
    /// The top most view controller
    static var visibleViewContoller: UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController?.currentVisibleViewController
    }

}

extension UIViewController {
    /// The visible view controller from a given view controller
    var currentVisibleViewController: UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController?.currentVisibleViewController
        } else if let presentedViewController = presentedViewController {
            return presentedViewController.currentVisibleViewController
        } else {
            return self
        }
    }
}

