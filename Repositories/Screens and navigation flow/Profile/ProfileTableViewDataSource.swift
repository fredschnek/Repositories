//
//  ProfileTableViewDataSource.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class ProfileTableViewDataSource: NSObject {
    private let user: User
    private let organizer: DataOrganizer
    
    init(user: User) {
        self.user = user
        organizer = DataOrganizer(user: user)
    }
    
    func section(at index: Int) -> ProfileViewController.Section {
        return organizer.section(at: index)
    }
}

// MARK: UITableViewDataSource
extension ProfileTableViewDataSource: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return organizer.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizer.rowsCount(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = organizer.row(at: indexPath)
        let cell = tableView.dequeueReusableCell(with: row.cellType, for: indexPath)
        let section = organizer.section(at: indexPath.section)
        cell.separator = section.separator
        if let configurableCell = cell as? UserConfigurable {
            configurableCell.configureWith(user: user, row: row)
        }
        return cell
    }
}

// MARK: - DataOrganizer
extension ProfileTableViewDataSource {
    struct DataOrganizer {
        private let sections: [ProfileViewController.Section]
        
        var sectionsCount: Int {
            return sections.count
        }
        
        init(user: User) {
            let sections: [ProfileViewController.Section] = [
                .summary([.avatar, .name, .username, .bio].filter { user[$0] != nil }),
                .details([.email, .blog, .company, .location].filter { !user[$0].isEmpty }),
                .lists([.repositories, .stars, .followers, .following].filter { user[$0] != 0 })
            ]
            self.sections = sections.filter({ !$0.rows.isEmpty })
        }
        
        func section(at index: Int) -> ProfileViewController.Section {
            return sections[index]
        }
        
        func rowsCount(for section: Int) -> Int {
            return sections[section].rows.count
        }
        
        func row(at indexPath: IndexPath) -> RowType {
            return sections[indexPath.section].rows[indexPath.row]
        }
    }
}

// MARK: RowConfigurable
protocol UserConfigurable {
    func configureWith(user: User, row: RowType)
}

extension AvatarCell: UserConfigurable {
    func configureWith(user: User, row: RowType) {
        avatar = #imageLiteral(resourceName: "avatar")
    }
}

extension SummaryCell: UserConfigurable {
    func configureWith(user: User, row: RowType) {
        guard let row = row as? ProfileViewController.Section.SummaryRow else {
            assertionFailure("SummaryCell needs a row of type SummaryRow")
            return
        }
        viewModel = ViewModel(text: user[row] as? String ?? "", style: row.style)
    }
}

extension DetailCell: UserConfigurable {
    func configureWith(user: User, row: RowType) {
        guard let row = row as? ProfileViewController.Section.DetailRow else {
            assertionFailure("DetailCell needs a row of type DetailRow")
            return
        }
        viewModel = ViewModel(icon: row.icon, text: user[row], active: row.isActive)
    }
}

extension ListCell: UserConfigurable {
    func configureWith(user: User, row: RowType) {
        guard let row = row as? ProfileViewController.Section.ListRow else {
            assertionFailure("ListCell needs a row of type ListRow")
            return
        }
        viewModel = ViewModel(count: user[row], name: row.name)
    }
}
