//
//  RepositoryCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit
import Foundation

class RepositoryCell: UITableViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var languageImageView: UIImageView!
    @IBOutlet private weak var dateLabel: UILabel!
    
    var viewModel = ViewModel() {
        didSet {
            nameLabel.text = viewModel.name
            usernameLabel.text = viewModel.username
            descriptionLabel.text = viewModel.description
            descriptionLabel.isHidden = viewModel.description.isEmpty
            languageLabel.text = viewModel.language
            languageImageView.isHidden = viewModel.language.isEmpty
            avatarImageView.image = viewModel.avatar
            forksLabel.text = viewModel.forksText
            starsLabel.text = viewModel.starsText
            dateLabel.text = viewModel.dateText
        }
    }
}

// MARK: - ViewModel
extension RepositoryCell {
    struct ViewModel {
        var name = ""
        var username = ""
        var description = ""
        var language = ""
        var starsCount = 0
        var forksCount = 0
        var avatar = UIImage()
        var date = Date()
        
        var starsText: String {
            return "\(starsCount)"
        }
        
        var forksText: String {
            return "\(forksCount)"
        }
        
        var dateText: String {
            return date.dateText
        }
    }
}

