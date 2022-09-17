//
//  CachingPolicyTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import XCTest
@testable import Repositories

fileprivate typealias Policy = CachingController.CachingPolicy

// MARK: CachingControllerCackingPolicyTests
class CachingControllerCachingPolicyTests: XCTestCase {
    let storedValue = StoredValue(value: 5, date: Date(string: "26/07/2017 12:40:00")!)
    
    func testCacheLimit() {
        XCTAssertTrue(Policy.isCacheSizeOverLimit(cacheSize: Policy.maximumCacheSize + Bytes(100)))
        XCTAssertFalse(Policy.isCacheSizeOverLimit(cacheSize: Policy.maximumCacheSize - Bytes(100)))
    }
    
    func testValidValue() {
        let currentDate = Date(string: "26/07/2017 12:45:00")!
        let cachedValue = Policy.cachedValue(from: storedValue, withCurrentDate: currentDate)
        XCTAssertEqual(cachedValue.value, 5)
        XCTAssert(!cachedValue.isStale)
    }
    
    func testExpiredValue() {
        let currentDate = Date(string: "26/07/2017 12:51:00")!
        let cachedValue = Policy.cachedValue(from: storedValue, withCurrentDate: currentDate)
        XCTAssert(cachedValue.isStale)
    }
    
    func testEntriesToRemove() {
        let url = URL(string: "www.test.com")!
        let dateToRemove1 = Date(string: "01/01/2017 12:45:00")!
        let dateToRemove2 = Date(string: "02/02/2017 12:45:00")!
        let dateToRemove3 = Date(string: "12/05/2017 12:45:00")!
        let entries = [
            StoredEntry(url: url, date: Date(string: "26/07/2017 12:45:00")!, size: 1000 * 1024),
            StoredEntry(url: url, date: Date(string: "28/07/2017 12:45:00")!, size: 3000 * 1024),
            StoredEntry(url: url, date: dateToRemove3, size: 1500 * 1024),
            StoredEntry(url: url, date: dateToRemove1, size: 1500 * 1024),
            StoredEntry(url: url, date: Date(string: "14/09/2017 12:45:00")!, size: 3000 * 1024),
            StoredEntry(url: url, date: Date(string: "30/11/2017 12:45:00")!, size: 2000 * 1024),
            StoredEntry(url: url, date: dateToRemove2, size: 1500 * 1024)
        ]
        let entriesToRemove = Policy.entriesToRemove(from: entries)
        XCTAssertEqual(entriesToRemove.count, 3)
        XCTAssertEqual(entriesToRemove[0].date, dateToRemove1)
        XCTAssertEqual(entriesToRemove[1].date, dateToRemove2)
        XCTAssertEqual(entriesToRemove[2].date, dateToRemove3)
    }
}

