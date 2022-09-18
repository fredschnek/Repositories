//
//  UsersViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit

class UsersViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: UsersTableViewDataSource?
}

// MARK: - Lifecycle

extension UsersViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let users: [User] = Loader.loadDataFromJSONFile(withName: "Users") else {
            return
        }
        let dataSource = UsersTableViewDataSource(users: users)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
