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

protocol Stateful: AnyObject {
    var stateController: StateController? { get set }
}

// MARK: - MainFlowCoordinator
class MainFlowCoordinator: NSObject {
    let stateController = StateController()
    let usersFlowCoordinator = UsersFlowCoordinator()
    
    override init() {
        super.init()
        usersFlowCoordinator.parent = self
    }
    
    func viewController(_ viewController: UIViewController, didSelectURL url: URL) {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.delegate = self
        viewController.present(safariViewController, animated: true, completion: nil)
    }
}

// MARK: Coordinator
extension MainFlowCoordinator: Coordinator {
    func configure(viewController: UIViewController) {
        (viewController as? MainCoordinated)?.mainCoordinator = self
        (viewController as? UsersCoordinated)?.usersCoordinator = usersFlowCoordinator
        (viewController as? Stateful)?.stateController = stateController
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

