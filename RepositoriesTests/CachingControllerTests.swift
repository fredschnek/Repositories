//
//  CachingControllerTests.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import XCTest
@testable import Repositories

fileprivate typealias Policy = CachingController.CachingPolicy

// MARK: - CachingControllerCachingPolicyTests

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

// MARK: - CachingControllerTests

class CachingControllerTests: XCTestCase {
    var mock: MockCache!
    var controller: CachingController!
    
    override func setUp() {
        mock = MockCache()
        controller = CachingController()
        controller.cacheController = mock
    }
    
    func testValidValue() {
        mock.storedValue = StoredValue(value: 5, date: Date())
        guard let cachedValue: CachedValue<Int> = controller.fetchValue(for: mock.url) else {
            XCTFail(" The caching controller does not return the stored value ")
            return
        }
        XCTAssertFalse(cachedValue.isStale)
        XCTAssertEqual(cachedValue.value, 5)
    }
    
    func testExpiredValue() {
        let expiredDate = Date(timeIntervalSinceNow: -CachingController.CachingPolicy.expirationTime)
        let storedValue = StoredValue(value: 5, date: expiredDate)
        mock.storedValue = storedValue
        guard let cachedValue: CachedValue<Int> = controller.fetchValue(for: mock.url) else {
            XCTFail(" The caching controller does not return the stored value ")
            return
        }
        XCTAssert(cachedValue.isStale)
        XCTAssertEqual(cachedValue.value, 5)
    }
    
    func testCacheMiss() {
        mock.storedValue = nil
        let cachedValue: CachedValue<Int>? = controller.fetchValue(for: mock.url)
        XCTAssertNil(cachedValue)
    }
    
    func testStoring() {
        controller.store(value: 5, for: mock.url)
        XCTAssert(mock.valueWasStored)
        XCTAssert(mock.valueWasRemoved)
    }
}

// MARK: - MockCache

class MockCache {
    let url = URL(string: "www.test.com/value")!
    let valueSize = CachingController.CachingPolicy.maximumCacheSize + 1
    var storedValue: StoredValue<Int>?
    private (set) var valueWasRemoved = false
    private (set) var valueWasStored = false
}

extension MockCache: Caching {
    func fetchValue<T: Decodable>(for url: URL) -> StoredValue<T>? {
        return storedValue as? StoredValue
    }
    
    func store<T>(value: T, for url: URL) where T : Encodable {
        valueWasStored = true
    }
    
    func removeValue(for url: URL) {
        valueWasRemoved = true
    }
    
    var cacheSize: Bytes {
        return valueWasRemoved ? 0 : valueSize
    }
    
    var entries: [StoredEntry] {
        return [StoredEntry(url: url, date: Date(), size: valueSize)]
    }
}
