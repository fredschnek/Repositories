//
//  RepositoryCellTests.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import XCTest
@testable import Repositories

class RepositoryCellTests: XCTestCase {
	func testViewModel() {
		var viewModel = RepositoryCell.ViewModel()
		viewModel.starsCount = 2
		viewModel.forksCount = 3
		XCTAssertEqual(viewModel.starsText, "2")
		XCTAssertEqual(viewModel.forksText, "3")
	}
}
