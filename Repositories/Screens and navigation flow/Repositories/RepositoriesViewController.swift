//
//  RepositoriesViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit

class RepositoriesViewController: UIViewController, Stateful, MainCoordinated {
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: RepositoriesTableViewDataSource?
    
    var stateController: StateController?
    weak var mainCoordinator: MainFlowCoordinator?
}

// MARK: UIViewController

extension RepositoriesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repositories = stateController?.repositories else {
            return
        }
        let dataSource = RepositoriesTableViewDataSource(repositories: repositories)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
}
