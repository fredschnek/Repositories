//
//  UINavigationBar+Extension.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 18/09/22.
//

import UIKit

extension UINavigationBar {
	static func setCustomAppearance() {
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().barTintColor = .mediumCarmine
		UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
	}
}
