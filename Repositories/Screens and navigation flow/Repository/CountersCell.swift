//
//  CountersCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class CountersCell: UITableViewCell {
    @IBOutlet private weak var starsLabel: UILabel!
    @IBOutlet private weak var forksLabel: UILabel!
    
    var viewModel = ViewModel() {
        didSet {
            starsLabel.text = viewModel.starsText
            forksLabel.text = viewModel.forksText
        }
    }
}

// MARK: - ViewModel
extension CountersCell {
    struct ViewModel {
        var starsCount = 0
        var forksCount = 0
        
        var starsText: String {
            return "\(starsCount)"
        }
        
        var forksText: String {
            return "\(forksCount)"
        }
    }
}
