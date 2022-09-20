//
//  ListCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class ListCell: UITableViewCell {
    @IBOutlet private weak var countLabel: PaddedLabel!
    @IBOutlet private weak var sectionLabel: UILabel!
    
    var viewModel = ViewModel() {
        didSet {
            countLabel.text = viewModel.countText
            sectionLabel.text = viewModel.name
        }
    }
}

// MARK: - ViewModel
extension ListCell {
    struct ViewModel {
        var count = 0
        var name = ""
        
        var countText: String {
            return "\(count)"
        }
    }
}
