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

// MARK: - ArrayTableViewDataSourceTests

class ArrayTableViewDataSourceTests: XCTestCase {
    func testCellDequeingAndConfiguring() {
        let mockDataSource = MockDataSource()
        let mockTableView = PartialMockTableView()
        _ = mockDataSource.cell(from: mockTableView, for: IndexPath(row: 4, section: 0))
        XCTAssert(mockTableView.didDequeueCell)
        XCTAssertEqual(mockDataSource.usedViewModel, "7")
    }
    
    func testViewModelCaching() {
        let mock = MockDataSource()
        let indexPath = IndexPath(row: 0, section: 0)
        let spy = PartialMockTableView()
        _ = mock.cell(from: spy, for: indexPath)
        XCTAssertEqual(mock.viewModelCache[indexPath], "1")
    }
}

// MARK: - MockDataSource

class MockDataSource {
    let dataOrganizer = ArrayDataSourceOrganizer(items: [1, 2, 3, 5, 7])
    var viewModelCache: [IndexPath : String] = [:]
    private (set) var usedViewModel = ""
}

extension MockDataSource: ArrayTableViewDataSource {
    typealias ModelType = Int
    typealias ViewModel = String
    typealias Cell = UITableViewCell
    
    func viewModel(for value: Int) -> String {
        return "\(value)"
    }
    
    func configure(cell: UITableViewCell, with viewModel: String) {
        usedViewModel = viewModel
    }
}

// MARK: - PartialMockTableView

class PartialMockTableView: UITableView {
    private (set) var didDequeueCell = false
    
    override func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        didDequeueCell = true
        return UITableViewCell()
    }
}
