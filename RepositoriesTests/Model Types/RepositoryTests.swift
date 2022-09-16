//
//  RepositoryTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import XCTest
@testable import Repositories

class RepositoryTests: XCTestCase {
    func testRepositoryDecoding() {
        let repository: Repository = openJsonFile(withName: "Repository")!
        XCTAssertEqual(repository.id.value, 1296269)
        XCTAssertEqual(repository.name, "Hello-World")
        XCTAssertEqual(repository.isFork, true)
        XCTAssertEqual(repository.forksCount, 9)
        XCTAssertEqual(repository.owner.id.value, 1)
        XCTAssertEqual(repository.description, "This your first repo!")
        XCTAssertNil(repository.language)
        XCTAssertNil(repository.parent)
    }
}
