//
//  UIView+Extension.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 18/09/22.
//

import UIKit

@IBDesignable
class DesignableImageView: UIImageView {}

extension UIView {
	@IBInspectable
	var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
			layer.cornerRadius = newValue
			layer.masksToBounds = newValue > 0
		}
	}
	
	@IBInspectable
	var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	
	@IBInspectable
	var borderColor: UIColor? {
		get {
			return layer.borderColor.flatMap { UIColor(cgColor: $0) }
		}
		set {
			layer.borderColor = newValue?.cgColor 
		}
	}
}
