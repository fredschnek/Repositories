//
//  UserTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import XCTest
@testable import Repositories

class UserTests: XCTestCase {
    func testUserDecoding() {
        let user: User = openJsonFile(withName: "User")!
        verifyStandardFields(in: user)
        guard case let .fetched(details) = user.details.value else {
            XCTFail("There are no details present")
            return
        }
        XCTAssertEqual(details.publicRepositoriesCount, 2)
        XCTAssertEqual(details.followersCount, 20)
        XCTAssertEqual(details.followingCount, 15)
        XCTAssertEqual(details.name, "monalisa octocat")
        XCTAssertEqual(details.company, "GitHub")
        XCTAssertEqual(details.location, "San Francisco")
        XCTAssertEqual(details.email, "octocat@github.com")
        XCTAssertEqual(details.bio, "There once was...")
        XCTAssertEqual(details.blog?.absoluteString, "https://github.com/blog")
    }
    
    func testPartailUserDecoding() {
        let user: User = openJsonFile(withName: "PartialUser")!
        verifyStandardFields(in: user)
        verify(url: "https://api.github.com/users/octocat", in: user.details)
    }
}

private extension UserTests {
    func verifyStandardFields(in user: User, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(user.login, "octocat")
        XCTAssertEqual(user.id.value, 1)
        verify(url: "https://github.com/images/error/octocat_happy.gif", in: user.avatar, file: file, line: line)
        verify(url: "https://api.github.com/users/octocat/repos", in: user.repositories, file: file, line: line)
        verify(url: "https://api.github.com/users/octocat/starred", in: user.stars, file: file, line: line)
        verify(url: "https://api.github.com/users/octocat/followers", in: user.followers, file: file, line: line)
        verify(url: "https://api.github.com/users/octocat/following", in: user.following, file: file, line: line)
    }
}
