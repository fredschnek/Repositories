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
    
    private let transducer: MainTabBarControllerTransducer = MainTabBarControllerTransducer()
    private var root = FetchableValue<GitHubRoot>(url: GitHubEndpoint.apiRootURL, value: .notFetched)
    private var error: Error?
    
    var isTabBarEnabled: Bool = true {
        didSet {
            tabBar.items?.forEach( { $0.isEnabled = isTabBarEnabled })
        }
    }
    
    var isClientAuthenticated: Bool {
        return networkController?.isClientAuthenticated ?? false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isTabBarEnabled = false
        transducer.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transducer.fire(.load(authenticated: isClientAuthenticated))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        loginCoordinator?.configure(viewController: segue.destination)
    }
}

extension MainTabBarController: MainTabBarControllerTransducerDelegate {
    func fetchRoot() {
        networkController?.fetchValue(for: GitHubEndpoint.apiRootURL) { [weak self] (result: Result<GitHubRoot>) in
            do {
                let root = try result.get()
                self?.root.value = .fetched(value: root)
                self?.transducer.fire(.rootFetched)
            } catch {
                let authenticated = (error as? NetworkError) != .unauthorized
                self?.error = error
                self?.transducer.fire(.errorOccurred(authenticated: authenticated))
            }
        }
    }
        
    func finishLaunch() {
        isTabBarEnabled = true
        root.fetchedValue.map { mainCoordinator?.mainViewController(self, didLoadGitHubRoot: $0) }
    }
    
    func authenticate() {
        loginCoordinator?.mainViewControllerRequiresAuthentication(self, isAppLaunch: error == nil)
    }
    
    func showAlert() {
        guard let error = error as? NetworkError else { return }
        
        mainCoordinator?.showAlert(for: error, withActionTitle: "Retry") { [weak self] in
            self.map { $0.transducer.fire(.load(authenticated: $0.isClientAuthenticated)) }
        }
    }
}
