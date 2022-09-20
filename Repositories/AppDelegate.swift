//
//  AppDelegate.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let coordinator = MainFlowCoordinator()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.setCustomAppearance()
        UITabBar.setCustomAppearance()
        
        if let initialViewController = window?.rootViewController {
            coordinator.configure(viewController: initialViewController)
        }
        
        return true
    }

}

