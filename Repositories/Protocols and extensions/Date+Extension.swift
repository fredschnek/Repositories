//
//  Date+Extension.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 18/09/22.
//

import Foundation

extension Date {
	var dateText: String {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .none
		let formatted = formatter.string(from: self)
		return "Updated on " + formatted
	}
}
