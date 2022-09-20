//
//  DescriptionCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!
    
    var descriptionText: String = "" {
        didSet {
            label.text = descriptionText
        }
    }
}
