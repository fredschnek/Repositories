//
//  RepositoryTableViewDataSource.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class RepositoryTableViewDataSource: NSObject {
    private let organizer: DataOrganizer
    private let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
        organizer = DataOrganizer(repository: repository)
    }
    
    func row(at index: Int) -> RepositoryViewController.Row {
        return organizer.row(at: index)
    }
}

// MARK: UITableViewDataSource

extension RepositoryTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizer.rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = organizer.row(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(with: row.cellType, for: indexPath)
        if let configurableCell = cell as? RepositoryConfigurable {
            configurableCell.configure(with: repository)
        }
        return cell
    }
}

// MARK: - DataOrganizer

extension RepositoryTableViewDataSource {
    struct DataOrganizer {
        private let rows: [RepositoryViewController.Row]
        
        var rowsCount: Int {
            return rows.count
        }
        
        init(repository: Repository) {
            var rows: [RepositoryViewController.Row] = []
            rows.append(.name)
            if repository.isFork {
                rows.append(.parent)
            }
            rows.append(.owner)
            rows.append(.description)
            rows.append(.counters)
            rows.append(.date)
            if case let .fetched(readme) = repository.readMe.value, !readme.isEmpty {
                rows.append(.readme)
            }
            self.rows = rows
        }
        
        func row(at index: Int) -> RepositoryViewController.Row {
            return rows[index]
        }
    }
}

// MARK: - OwnerCell.ViewModel

extension OwnerCell.ViewModel {
    init(repository: Repository) {
        avatar = #imageLiteral(resourceName: "Avatar")
        let owner = repository.owner
        username = owner.login
        if case let .fetched(details) = owner.details.value {
            name = details.name ?? ""
        }
    }
}

// MARK: - CountersCell.ViewModel

extension CountersCell.ViewModel {
    init(repository: Repository) {
        starsCount = repository.stargazersCount
        forksCount = repository.forksCount
    }
}

// MARK: - RepositoryConfigurable

protocol RepositoryConfigurable {
    func configure(with repository: Repository)
}

extension RepositoryNameCell: RepositoryConfigurable {
    func configure(with repository: Repository) {
        name = repository.name
    }
}

extension ParentCell: RepositoryConfigurable {
    func configure(with repository: Repository) {
        let parent = repository.parent as! Repository
        parentName = parent.name
    }
}

extension OwnerCell: RepositoryConfigurable {
    func configure(with repository: Repository) {
        viewModel = ViewModel(repository: repository)
    }
}

extension DescriptionCell: RepositoryConfigurable {
    func configure(with repository: Repository) {
        descriptionText = repository.description ?? ""
    }
}

extension CountersCell: RepositoryConfigurable {
    func configure(with repository: Repository) {
        viewModel = ViewModel(repository: repository)
    }
}

extension DateCell: RepositoryConfigurable {
    func configure(with repository: Repository) {
        viewModel = ViewModel(date: repository.updateDate)
    }
}

extension ReadmeCell: RepositoryConfigurable {
    func configure(with repository: Repository) {}
}
