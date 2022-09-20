//
//  DetailCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class DetailCell: UITableViewCell {
    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var label: UILabel!
    
    var viewModel: ViewModel = ViewModel() {
        didSet {
            iconImageView.image = viewModel.icon
            label.text = viewModel.text
            label.textColor = viewModel.active ? .mediumCarmine : .cork
        }
    }
}

// MARK: - ViewModel
extension DetailCell {
    struct ViewModel {
        var icon: UIImage = UIImage()
        var text: String = ""
        var active: Bool = false
    }
}
