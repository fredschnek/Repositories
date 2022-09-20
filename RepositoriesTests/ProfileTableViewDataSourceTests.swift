//
//  ProfileTableViewDataSourceTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import XCTest
@testable import Repositories

class ProfileTableViewDataSourceTests: XCTestCase {
    func testSections() {
        let user: User = openJsonFile(withName: "User")!
        let organizer = ProfileTableViewDataSource.DataOrganizer(user: user)
        XCTAssertEqual(organizer.sectionsCount, 3)
        // Warning: the following if cases have an atypical form. Beware of the empty bodies.
        if case ProfileViewController.Section.summary(_) = organizer.section(at: 0) {} else { XCTFail() }
        if case ProfileViewController.Section.details(_) = organizer.section(at: 1) {} else { XCTFail() }
        if case ProfileViewController.Section.lists(_) = organizer.section(at: 2) {} else { XCTFail() }
    }
    
    func testRows() {
        var user: User = openJsonFile(withName: "User")!
        user.stars.value = .fetched(value: openJsonFile(withName: "Repositories")!)
        let organizer = ProfileTableViewDataSource.DataOrganizer(user: user)
        XCTAssertEqual(organizer.rowsCount(for: 0), 4)
        typealias SummaryRow = ProfileViewController.Section.SummaryRow
        XCTAssertEqual(organizer.row(at: IndexPath(row: 0, section: 0)) as? SummaryRow, .avatar)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 1, section: 0)) as? SummaryRow, .name)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 2, section: 0)) as? SummaryRow, .username)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 3, section: 0)) as? SummaryRow, .bio)
        XCTAssertEqual(organizer.rowsCount(for: 1), 4)
        typealias DetailRow = ProfileViewController.Section.DetailRow
        XCTAssertEqual(organizer.row(at: IndexPath(row: 0, section: 1)) as? DetailRow, .email)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 1, section: 1)) as? DetailRow, .blog)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 2, section: 1)) as? DetailRow, .company)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 3, section: 1)) as? DetailRow, .location)
        XCTAssertEqual(organizer.rowsCount(for: 2), 4)
        typealias ListRow = ProfileViewController.Section.ListRow
        XCTAssertEqual(organizer.row(at: IndexPath(row: 0, section: 2)) as? ListRow, .repositories)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 1, section: 2)) as? ListRow, .stars)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 2, section: 2)) as? ListRow, .followers)
        XCTAssertEqual(organizer.row(at: IndexPath(row: 3, section: 2)) as? ListRow, .following)
    }
    
    func testMissingRows() {
        var user: User = openJsonFile(withName: "User")!
        let details = User.Details(publicRepositoriesCount: 0, followersCount: 0, followingCount: 0, name: nil, company: nil, location: nil, email: nil, bio: nil, blog: nil)
        user.details = FetchableValue(url: URL(string: "www.test.com")!, value: .fetched(value: details))
        let organizer = ProfileTableViewDataSource.DataOrganizer(user: user)
        XCTAssertEqual(organizer.sectionsCount, 1)
        XCTAssertEqual(organizer.rowsCount(for: 0), 2)
    }
}
