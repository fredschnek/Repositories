//
//  MainFlowCoordinator.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 20/09/22.
//

import UIKit
import MessageUI
import SafariServices

// MARK: Protocols

protocol Coordinator: AnyObject {
    func configure(viewController: UIViewController)
}

protocol MainCoordinated: AnyObject {
    var mainCoordinator: MainFlowCoordinator? { get set }
}

protocol UsersCoordinated: AnyObject {
    var usersCoordinator: UsersFlowCoordinator? { get set }
}

protocol LoginCoordinated: AnyObject {
    var loginCoordinator: LoginFlowCoordinator? { get set }
}

protocol Stateful: AnyObject {
    var stateController: StateController? { get set }
}

protocol Networked: AnyObject {
    var networkController: NetworkController? { get set }
}

// MARK: - MainFlowCoordinator

class MainFlowCoordinator: NSObject {
    let stateController = StateController()
    let keyChainController = KeychainController()
    let cachingController = CachingController()
    let mainTabBarController: MainTabBarController
    let usersFlowCoordinator = UsersFlowCoordinator()
    let loginFlowCoordinator = LoginFlowCoordinator()
    
    init(mainViewController: MainTabBarController) {
        self.mainTabBarController = mainViewController
        super.init()
        usersFlowCoordinator.parent = self
        loginFlowCoordinator.parent = self
        configure(viewController: mainViewController)
    }
    
    func viewController(_ viewController: UIViewController, didSelectURL url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        viewController.present(safariViewController, animated: true, completion: nil)
    }
    
    func mainViewController(_ viewController: MainTabBarController, didLoadGitHubRoot root: GitHubRoot) {
        viewController.viewControllers?.forEach({ child in
            guard let navigationController = child as? UINavigationController,
                  let viewController = navigationController.viewControllers.first else {
                return
            }
            (viewController as? ProfileViewController)?.user = root.user
        })
    }
    
    func logOut() {
        loginFlowCoordinator.mainViewControllerRequiresAuthentication(mainTabBarController, isAppLaunch: false)
    }
}

// MARK: Coordinator

extension MainFlowCoordinator: Coordinator {
    func configure(viewController: UIViewController) {
        (viewController as? MainCoordinated)?.mainCoordinator = self
        (viewController as? UsersCoordinated)?.usersCoordinator = usersFlowCoordinator
        (viewController as? LoginCoordinated)?.loginCoordinator = loginFlowCoordinator
        (viewController as? Stateful)?.stateController = stateController
        (viewController as? Networked)?.networkController = NetworkController(keychainController: keyChainController, cachingController: cachingController)
        if let tabBarController = viewController as? UITabBarController {
            tabBarController.viewControllers?.forEach(configure(viewController:))
        }
        if let navigationController = viewController as? UINavigationController,
           let rootViewController = navigationController.viewControllers.first {
            configure(viewController: rootViewController)
        }
    }
}

// MARK: SFSafariViewControllerDelegate

extension MainFlowCoordinator: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
