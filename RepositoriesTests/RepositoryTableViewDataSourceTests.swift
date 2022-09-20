//
//  RepositoryTableViewDataSourceTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import XCTest
@testable import Repositories

class RepositoryTableViewDataSourceTests: XCTestCase {
    func testRows() {
        var repository: Repository = openJsonFile(withName: "Repository")!
        repository.readMe.value = .fetched(value: "Lorem ipsum")
        let organizer = RepositoryTableViewDataSource.DataOrganizer(repository: repository)
        XCTAssertEqual(organizer.rowsCount, 7)
        XCTAssertEqual(organizer.row(at: 0), .name)
        XCTAssertEqual(organizer.row(at: 1), .parent)
        XCTAssertEqual(organizer.row(at: 2), .owner)
        XCTAssertEqual(organizer.row(at: 3), .description)
        XCTAssertEqual(organizer.row(at: 4), .counters)
        XCTAssertEqual(organizer.row(at: 5), .date)
        XCTAssertEqual(organizer.row(at: 6), .readme)
    }
    
    func testMissingRows() {
        let dummy: Repository = openJsonFile(withName: "Repository")!
        let repository = Repository(
            id: dummy.id,
            name: dummy.name,
            isFork: false,
            forksCount: 0,
            stargazersCount: 0,
            owner: dummy.owner,
            updateDate: dummy.updateDate,
            description: "",
            language: "",
            parent: nil,
            readMe: dummy.readMe,
            isStarred: dummy.isStarred
        )
        let organizer = RepositoryTableViewDataSource.DataOrganizer(repository: repository)
        XCTAssertEqual(organizer.rowsCount, 5)
    }
}
