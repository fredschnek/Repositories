//
//  GitHubRootTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import XCTest
@testable import Repositories

class GitHubRootTests: XCTestCase {
    func testDecoding() {
        let root: GitHubRoot = openJsonFile(withName: "Root")!
        verify(url: "https://api.github.com/user", in: root.user)
    }
}
