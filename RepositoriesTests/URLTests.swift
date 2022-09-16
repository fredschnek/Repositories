//
//  URLTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import XCTest
@testable import Repositories

class URLTests: XCTestCase {
    func testInitFromTemplate() {
        let template = "https://api.github.com/users/octocat/starred{/owner}{/repo}"
        guard let url = URL(template: template) else {
            XCTFail("The initialization failed")
            return
        }
        XCTAssertEqual(url.absoluteString, "https://api.github.com/users/octocat/starred")
    }
}

