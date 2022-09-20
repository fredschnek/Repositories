//
//  AvatarCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

class AvatarCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    
    var avatar = UIImage() {
        didSet {
            avatarImageView.image = avatar
        }
    }
}
