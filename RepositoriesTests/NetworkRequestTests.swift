//
//  NetworkRequestTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 20/09/22.
//

import XCTest
@testable import Repositories

class NetworkRequestTests: XCTestCase {
    func testRequestExecution() {
        let session = PartialMockSession()
        let request = MockRequest(session: session)
        request.execute { _ in
            XCTAssertEqual(request.data, PartialMockDataTask.dummyData)
            XCTAssertEqual(request.response, PartialMockDataTask.dummyResponse)
        }
    }
}

// MARK: - PartialMockDataTask

class PartialMockDataTask: URLSessionDataTask {
    static let dummyData = Data()
    static let dummyResponse = URLResponse(url: URL(string: "test.com")!, mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    let completionHandler: (Data?, URLResponse?, Error?) -> Void
    
    init(completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler(PartialMockDataTask.dummyData, PartialMockDataTask.dummyResponse, nil)
    }
}

// MARK: - PartialMockSession

class PartialMockSession: URLSession {
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return PartialMockDataTask(completionHandler: completionHandler)
    }
}

// MARK: - MockRequest

class MockRequest: NetworkRequest {
    typealias ModelType = Int
    let session: URLSession
    var task: URLSessionDataTask?
    var data: Data?
    var response: URLResponse?
    
    init(session: URLSession) {
        self.session = session
    }
    
    func deserialize(_ data: Data?, response: URLResponse?) -> Int? {
        self.data = data
        self.response = response
        return nil
    }
    
    var urlRequest: URLRequest {
        return URLRequest(url: URL(string: "test.com")!)
    }
}

