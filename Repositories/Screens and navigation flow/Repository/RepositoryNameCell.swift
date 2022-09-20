//
//  RepositoryNameCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class RepositoryNameCell: UITableViewCell {
    @IBOutlet private weak var label: UILabel!
    
    var name: String = "" {
        didSet {
            label.text = name
        }
    }
}
