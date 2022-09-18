//
//  ArrayTableViewDataSourceTests.swift
//  RepositoriesTests
//
//  Created by Matteo Manferdini on 18/11/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
//

import XCTest
@testable import Repositories

class ArrayDataSourceOrganizerTests: XCTestCase {
	func testRows() {
		let organizer = ArrayDataSourceOrganizer(items: [1, 2, 3, 5, 7])
		XCTAssertEqual(organizer.rowsCount, 5)
		let indexPath = IndexPath(row: 4, section: 0)
		XCTAssertEqual(organizer[indexPath], 7)
	}
}
