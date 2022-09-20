//
//  PaddedLabel.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//


import UIKit


@IBDesignable
class PaddedLabel: UILabel {
    @IBInspectable var verticalPadding: CGFloat = 0
    @IBInspectable var horizontalPadding: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + horizontalPadding, height: size.height + verticalPadding)
    }
}
