//
//  LoginFlowCoordinator.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import UIKit
import SafariServices

// MARK: - LoginFlowCoordinator

class LoginFlowCoordinator {
    weak var parent: Coordinator?
    weak var loginViewController: UIViewController?
    private var authenticationSession: SFAuthenticationSession?
    
    func mainViewControllerRequiresAuthentication(_ viewController: MainTabBarController, isAppLaunch: Bool) {
        let newViewController = viewController.storyboard?.instantiateViewController(withIdentifier: ViewControllerIDs.loginViewController)
        guard let loginViewController = newViewController as? LoginViewController else {
            return
        }
        self.loginViewController = loginViewController
        configure(viewController: loginViewController)
        loginViewController.presentedAfterLogout = !isAppLaunch
        loginViewController.modalTransitionStyle = isAppLaunch ? .crossDissolve : .coverVertical
        viewController.present(loginViewController, animated: !isAppLaunch, completion: nil)
    }
    
    func loginViewController(_ viewController: LoginViewController, didStartAuthorizationWithState state: String) {
        let url = GitHubEndpoint.authorizationUrl(with: state)
        authenticationSession = SFAuthenticationSession(url: url, callbackURLScheme: nil, completionHandler: { [weak self] (callbackURL, error) in
            self?.authenticationSession = nil
            if let authorizationCode = callbackURL?.authorizationCode {
                viewController.performAuthorization(with: authorizationCode)
            }
        })
        authenticationSession?.start()
    }
    
    func loginViewControllerDidFinishAuthorization() {
        loginViewController?.dismiss(animated: true, completion: nil)
    }
    
    func loginViewControllerDidSignOut() {
        UIApplication.shared.open(GitHubEndpoint.signOutURL, options: [:], completionHandler: nil)
    }
}

// MARK: Coordinator

extension LoginFlowCoordinator: Coordinator {
    func configure(viewController: UIViewController) {
        parent?.configure(viewController: viewController)
    }
}

// MARK: - ProfileViewControllerSegues

extension LoginFlowCoordinator {
    struct ViewControllerIDs {
        static let loginViewController = "LoginViewController"
    }
}

