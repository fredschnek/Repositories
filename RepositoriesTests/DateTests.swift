//
//  DateTests.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import XCTest
@testable import Repositories

class DateTests: XCTestCase {
	func testFormat() {
		let date = Date(string: "03/11/2017 12:00:00")!
		XCTAssertEqual(date.dateText, "Updated on November 3, 2017")
	}
}
