//
//  UsersViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit

class UsersViewController: UIViewController, Stateful, MainCoordinated {
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: UsersTableViewDataSource?
    
    var stateController: StateController?
    weak var mainCoordinator: MainFlowCoordinator?
}

// MARK: UIViewController

extension UsersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let users = stateController?.users else {
            return
        }
        let dataSource = UsersTableViewDataSource(users: users)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
}
