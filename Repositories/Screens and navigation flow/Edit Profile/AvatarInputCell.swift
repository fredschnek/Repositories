//
//  AvatarInputCell.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

protocol AvatarInputCellDelegate: AnyObject {
    func photoCellDidEditPhoto(_ cell: AvatarInputCell)
}

class AvatarInputCell: UITableViewCell {
    @IBOutlet private weak var avatarImageView: UIImageView!
    weak var delegate: AvatarInputCellDelegate?
    
    var avatar = UIImage() {
        didSet {
            avatarImageView.image = avatar
        }
    }
    
    @IBAction func changeAvatar(_ sender: Any) {
        delegate?.photoCellDidEditPhoto(self)
    }
}
