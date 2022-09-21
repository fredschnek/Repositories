//
//  LoginViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import UIKit

class LoginViewController: UIViewController, LoginCoordinated, Networked {
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var authenticatingView: UIStackView!
    @IBOutlet weak var safariLogoutView: UIStackView!
    
    private let state = UUID().description
    var presentedAfterLogout = false
    
    weak var loginCoordinator: LoginFlowCoordinator?
    var networkController: NetworkController?
    
    var isAuthenticating: Bool = false {
        didSet {
            loginButton.isEnabled = !isAuthenticating
            authenticatingView.isHidden = !isAuthenticating
        }
    }
    
    func performAuthorization(with authorizationCode: String) {
        isAuthenticating = true
        networkController?.authenticateWith(authorizationCode: authorizationCode, state: state) { [weak self] in
            self?.loginCoordinator?.loginViewControllerDidFinishAuthorization()
        }
    }
    
    @IBAction func login(_ sender: Any) {
        loginCoordinator?.loginViewController(self, didStartAuthorizationWithState: state)
    }
    
    @IBAction func signOut(_ sender: Any) {
        loginCoordinator?.loginViewControllerDidSignOut()
    }
}

// MARK: UIViewController

extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        isAuthenticating = false
        safariLogoutView.isHidden = !presentedAfterLogout
    }
}

