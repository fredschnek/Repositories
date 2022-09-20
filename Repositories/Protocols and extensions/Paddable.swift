//
//  Paddable.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import UIKit

protocol Paddable {
    var verticalPadding: CGFloat { get set }
    var horizontalPadding: CGFloat { get set }
}

extension Paddable {
    func pad(_ size: CGSize) -> CGSize {
        return CGSize(width: size.width + horizontalPadding, height: size.height + verticalPadding)
    }
}

@IBDesignable
class PaddedLabel: UILabel, Paddable {
    @IBInspectable var verticalPadding: CGFloat = 0
    @IBInspectable var horizontalPadding: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        return pad(super.intrinsicContentSize)
    }
}

@IBDesignable
class PaddedButton: UIButton, Paddable {
    @IBInspectable var verticalPadding: CGFloat = 0
    @IBInspectable var horizontalPadding: CGFloat = 0
    
    override var intrinsicContentSize: CGSize {
        return pad(super.intrinsicContentSize)
    }
}
