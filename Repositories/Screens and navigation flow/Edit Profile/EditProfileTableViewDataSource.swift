//
//  EditProfileTableViewDataSource.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class EditProfileTableViewDataSource: NSObject {
    private var organizer: DataOrganizer
    
    var isDataValid: Bool {
        return organizer.isDataValid
    }
    
    init(user: User) {
        organizer = DataOrganizer(user: user)
    }
    
    func set(text: String, at index: Int) {
        organizer.set(text: text, at: index)
    }
    
    func set(avatar: UIImage) {
        organizer.set(avatar: avatar)
    }
    
    func row(at index: Int) -> EditProfileViewController.Row {
        return organizer.row(at: index)
    }
}

// MARK: UITableViewDataSource
extension EditProfileTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizer.rowsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = organizer.row(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(with: row.cellType, for: indexPath)
        cell.separator = row.separator
        if let configurableCell = cell as? RowConfigurable {
            configurableCell.configure(with: row)
        }
        return cell
    }
}

// MARK: - DataOrganizer
extension EditProfileTableViewDataSource {
    struct DataOrganizer {
        private(set) var rows: [EditProfileViewController.Row]
        
        var rowsCount: Int {
            return rows.count
        }
        
        var isDataValid: Bool {
            for case let .blog(text) in rows {
                return text.isValidURL
            }
            return true
        }
        
        init(user: User) {
            let rows: [EditProfileViewController.Row] = [ .avatar(UIImage()), .name(""), .blog(""), .company(""), .location(""), .bio("")]
            self.rows = rows.map { user[$0] }
        }
        
        func row(at index: Int) -> EditProfileViewController.Row {
            return rows[index]
        }
        
        mutating func set(avatar: UIImage) {
            let avatarIndex: Int = {
                for (index, row) in rows.enumerated() {
                    if case .avatar = row {
                        return index
                    }
                }
                assertionFailure("Avatar not found")
                return 0
            }()
            rows[avatarIndex] = .avatar(avatar)
        }
        
        mutating func set(text: String, at index: Int) {
            let row = rows[index]
            rows[index] = {
                switch row {
                case .name: return .name(text)
                case .blog: return .blog(text)
                case .company: return .company(text)
                case .location: return .location(text)
                case .bio: return .bio(text)
                case .avatar:
                    assertionFailure("The avatar has no text")
                    return .avatar(UIImage())
                }
            }()
        }
    }
}

// MARK: RowConfigurable
protocol RowConfigurable {
    func configure(with row: EditProfileViewController.Row)
}

extension AvatarInputCell: RowConfigurable {
    func configure(with row: EditProfileViewController.Row) {
        avatar = #imageLiteral(resourceName: "avatar")
    }
}

extension DetailInputCell: RowConfigurable {
    func configure(with row: EditProfileViewController.Row) {
        switch row {
        case let .name(text), let .blog(text), let .company(text), let .location(text):
            let isValid: Bool = {
                if case .blog(_) = row {
                    return text.isValidURL
                } else {
                    return true
                }
            }()
            viewModel = ViewModel(label: row.label, text: text, placeholder: row.placeHolder, errorMessage: row.errorMessage, isValid: isValid)
        case .avatar, .bio:
            assertionFailure("InputCell is not configurable with an .avatar or .bio row")
        }
    }
}

extension BioInputCell: RowConfigurable {
    func configure(with row: EditProfileViewController.Row) {
        if case let .bio(text) = row {
            self.bioText = text
        } else {
            assertionFailure("BioInputCell is not configurable with a row other than .bio")
        }
    }
}

// MARK: - String
extension String {
    var isValidURL: Bool {
        return URL(string: self) != nil
    }
}
