//
//  SummaryCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class SummaryCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var bottomConstraint: NSLayoutConstraint!
    
    var viewModel: ViewModel = ViewModel() {
        didSet {
            label.text = viewModel.text
            let style = viewModel.style
            label.textColor = style.color
            label.textAlignment = style.alignment
            label.font = UIFont.systemFont(ofSize: style.size, weight: style.weight)
            bottomConstraint.constant = style.margin
        }
    }
}

// MARK: - ViewModel
extension SummaryCell {
    struct ViewModel {
        struct Style {
            var margin: CGFloat = 0
            var size: CGFloat = 0
            var weight = UIFont.Weight.regular
            var color = UIColor.clear
            var alignment = NSTextAlignment.left
        }
        
        var text = ""
        var style = Style()
    }
}
