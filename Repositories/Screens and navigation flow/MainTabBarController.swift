//
//  MainTabBarController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import UIKit

class MainTabBarController: UITabBarController, Networked, MainCoordinated, LoginCoordinated {
    var networkController: NetworkController?
    weak var mainCoordinator: MainFlowCoordinator?
    weak var loginCoordinator: LoginFlowCoordinator?
    
    private var root = FetchableValue<GitHubRoot>(url: GitHubEndpoint.apiRootURL, value: .notFetched)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard case .notFetched = root.value else {
            return
        }
        
        guard (networkController?.isClientAuthenticated ?? true) else {
            loginCoordinator?.mainViewControllerRequiresAuthentication(self, isAppLaunch: true)
            return
        }
        
        networkController?.fetchValue(for: GitHubEndpoint.apiRootURL) { [weak self] (result: Result<GitHubRoot>) in
            if let root = try? result.get(), let strongSelf = self {
                strongSelf.root.value = .fetched(value: root)
                strongSelf.mainCoordinator?.mainViewController(strongSelf, didLoadGitHubRoot: root)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        loginCoordinator?.configure(viewController: segue.destination)
    }
}
