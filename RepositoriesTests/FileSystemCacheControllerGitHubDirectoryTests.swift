//
//  FileSystemCacheControllerGitHubDirectoryTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import XCTest
@testable import Repositories

fileprivate typealias Directory = FileSystemCacheController.GitHubDirectory

class FileSystemCacheControllerGitHubDirectoryTests: XCTestCase {
    let testPath = "/testPath"
    
    fileprivate var directory: Directory {
        return Directory(iOSCachesDirectoryURL: URL(fileURLWithPath: testPath))
    }
    
    func testURL() {
        XCTAssertEqual(directory.baseURL.relativePath, testPath + "/" + Directory.name)
    }
    
    func testStorableData() {
        let url = URL(string: "https://api.github.com/users/octocat/starred")!
        let storableData = directory.makeStorableData(value: CodableStruct.testValue, url: url)
        XCTAssertNotNil(storableData)
    }
    
    func testValueFromData() {
        let data = try! JSONEncoder().encode(CodableStruct.testValue)
        let valueFromData: CodableStruct? = Directory.value(from: data)
        XCTAssertNotNil(valueFromData)
        XCTAssertEqual(valueFromData?.string, CodableStruct.testValue.string)
        XCTAssertEqual(valueFromData?.int, CodableStruct.testValue.int)
    }
}

struct CodableStruct: Codable {
    let string: String
    let int: Int
    
    static let testValue = CodableStruct(string: "aaa", int: 777)
}
