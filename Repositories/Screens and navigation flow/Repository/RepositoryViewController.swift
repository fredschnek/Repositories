//
//  RepositoryViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class RepositoryViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: RepositoryTableViewDataSource?
}

// MARK: UIViewController
extension RepositoryViewController {
    override func viewDidLoad() {
        guard var repository: Repository = Loader.loadDataFromJSONFile(withName: "Repository") else {
            return
        }
        let readMeURL = URL(string: "https://github.com/octokit/octokit.rb/blob/master/README.md")!
        repository.readMe = FetchableValue(url: readMeURL, value: .fetched(value: ""))
        let dataSource = RepositoryTableViewDataSource(repository: repository)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        super.viewDidLoad()
    }
}

// MARK: - Row
extension RepositoryViewController {
    enum Row {
        case name
        case parent
        case owner
        case description
        case counters
        case date
        case readme
        
        var cellType: UITableViewCell.Type {
            switch self {
            case .name: return RepositoryNameCell.self
            case .parent: return ParentCell.self
            case .owner: return OwnerCell.self
            case .description: return DescriptionCell.self
            case .counters: return CountersCell.self
            case .date: return DateCell.self
            case .readme: return ReadmeCell.self
            }
        }
    }
}
