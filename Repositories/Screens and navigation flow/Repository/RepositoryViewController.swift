//
//  RepositoryViewController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class RepositoryViewController: UIViewController, Stateful, MainCoordinated {
    @IBOutlet private weak var tableView: UITableView!
    private var dataSource: RepositoryTableViewDataSource?
    
    var stateController: StateController?
    weak var mainCoordinator: MainFlowCoordinator?
}

// MARK: UIViewController

extension RepositoryViewController {
    override func viewDidLoad() {
        guard let repository = stateController?.repository else {
            return
        }
        let dataSource = RepositoryTableViewDataSource(repository: repository)
        self.dataSource = dataSource
        tableView.dataSource = dataSource
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        mainCoordinator?.configure(viewController: segue.destination)
    }
}

// MARK: UITableViewDelegate

extension RepositoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dataSource = dataSource else {
            return
        }
        switch dataSource.row(at: indexPath.row) {
        case .readme:
            if let readmeURL = stateController?.repository?.readMe.url {
                mainCoordinator?.viewController(self, didSelectURL: readmeURL)
            }
        default: break
        }
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
