//
//  UITableView+Extension.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 18/09/22.
//

import UIKit

extension UITableView {
	func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
		return dequeueReusableCell(withIdentifier: String(describing: Cell.self), for: indexPath) as! Cell
	}
}
