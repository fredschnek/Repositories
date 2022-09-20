//
//  ParentCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class ParentCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!
    
    var parentName: String = "" {
        didSet {
            label.text = parentName
        }
    }
}
