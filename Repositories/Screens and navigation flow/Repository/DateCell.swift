//
//  DateCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class DateCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    
    var viewModel = ViewModel() {
        didSet {
            dateLabel.text = viewModel.dateText
        }
    }
}

// MARK: - ViewModel
extension DateCell {
    struct ViewModel {
        var date = Date()
        
        var dateText: String {
            return date.dateText
        }
    }
}
