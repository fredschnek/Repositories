//
//  FileSystemCacheControllerTests.swift
//  RepositoriesTests
//
//  Created by Matteo Manferdini on 25/07/2017.
//  Copyright © 2017 Pure Creek. All rights reserved.
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

// MARK: - FileSystemCacheControllerTests

class FileSystemCacheControllerTests: XCTestCase {
    let url = URL(string:"www.test.com")!
    let cachesDirectoryURL = URL(fileURLWithPath: "/caches")
    var controller: FileSystemCacheController!
    var mock: MockFileManager!
    
    override func setUp() {
        controller = FileSystemCacheController(cachesDirectoryURL: cachesDirectoryURL)
        mock = MockFileManager()
        controller.fileManager = mock
    }
    
    func testFileURL() {
        let testURL = "https://api.github.com/users/octocat/starred"
        let baseURL = "/directory"
        let fileURL = URL(string: testURL)!.fileUrl(withBaseURL: URL(fileURLWithPath: baseURL))
        XCTAssertNotNil(fileURL)
        XCTAssertEqual(fileURL?.absoluteString, "file:///directory/https%253A%252F%252Fapi%252Egithub%252Ecom%252Fusers%252Foctocat%252Fstarred.json")
    }
    
    func testStoringValue() {
        let gitHubDirectory = FileSystemCacheController.GitHubDirectory(iOSCachesDirectoryURL: cachesDirectoryURL)
        let path = url.fileUrl(withBaseURL: gitHubDirectory.baseURL)!.path
        controller.store(value: CodableStruct.testValue, for: url)
        XCTAssertNotNil(mock.storage[path])
    }
    
    func testRemovingValue() {
        controller.store(value: CodableStruct.testValue, for: url)
        controller.removeValue(for: URL(string:"www.test.com")!)
        XCTAssert(mock.storage.isEmpty)
    }
    
    func testFetchingValue() {
        controller.store(value: CodableStruct.testValue, for: url)
        let fetchedValue: StoredValue<CodableStruct>? = controller.fetchValue(for: url)
        XCTAssertNotNil(fetchedValue)
    }
    
    func testEntries() {
        XCTAssertEqual(controller.entries.count, 1)
    }
    
    func testCacheSize() {
        XCTAssertEqual(controller.cacheSize, Bytes(100))
    }
}

// MARK: - MockCacheManager

class MockFileManager {
    var storage: [String: Data] = [:]
}

extension MockFileManager: FileManaging {
    func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]? = nil) -> Bool {
        storage[path] = data!
        return true
    }
    
    func removeItem(at URL: URL) throws {
        storage[URL.path] = nil
    }
    
    func contents(atPath path: String) -> Data? {
        return storage[path]
    }
    
    func attributesOfItem(atPath path: String) throws -> [FileAttributeKey : Any] {
        return [FileAttributeKey.creationDate: Date(), FileAttributeKey.size: 100]
    }
    
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL] {
        return [url]
    }
}
