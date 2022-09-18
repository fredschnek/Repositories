//
//  UserCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit

class UserCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var locationStackView: UIStackView!
    @IBOutlet private weak var bioLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    var viewModel = ViewModel() {
        didSet {
            nameLabel.text = viewModel.name
            usernameLabel.text = viewModel.username
            locationLabel.text = viewModel.location
            locationLabel.isHidden = viewModel.location.isEmpty
            locationStackView.isHidden = viewModel.location.isEmpty
            avatarImageView.image = viewModel.avatar
            bioLabel.text = viewModel.bio
            bioLabel.isHidden = viewModel.bio.isEmpty
        }
    }
}

// MARK: - ViewModel
extension UserCell {
    struct ViewModel {
        var name = ""
        var username = ""
        var location = ""
        var bio = ""
        var avatar = UIImage()
    }
}
