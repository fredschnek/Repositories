//
//  FetchableValueTests.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import XCTest
@testable import Repositories


class FetchableValueTests: XCTestCase {
    func testCorruptedDataError() {
        let json = "{ \"avatar_url\": \"\" }"
            .data(using: .utf8)!
        XCTAssertThrowsError(try JSONDecoder().decode(TestStruct.self, from: json))
    }
}

private extension FetchableValueTests {
    struct TestStruct: Decodable {
        let testProperty: FetchableValue<Bool>
        
        enum CodingKeys: String, CodingKey {
            case avatar_url
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            testProperty = try container.decode(FetchableValue.self, forKey: .avatar_url)
        }
    }
}
