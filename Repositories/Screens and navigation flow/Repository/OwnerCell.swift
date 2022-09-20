//
//  OwnerCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class OwnerCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    
    var viewModel = ViewModel() {
        didSet {
            avatarImageView.image = viewModel.avatar
            nameLabel.text = viewModel.name
            usernameLabel.text = viewModel.username
        }
    }
}

// MARK: - ViewModel
extension OwnerCell {
    struct ViewModel {
        var avatar = UIImage()
        var name = ""
        var username = ""
    }
}
