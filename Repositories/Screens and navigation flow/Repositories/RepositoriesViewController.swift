//
//  RepositoriesViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit

class RepositoriesViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: RepositoriesTableViewDataSource?
}

// MARK: Lifecycle

extension RepositoriesViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let repositories: [Repository] = Loader.loadDataFromJSONFile(withName: "Repositories") else {
            return
        }
        let dataSource = RepositoriesTableViewDataSource(repositories: repositories)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        tableView.reloadData()
    }
}
