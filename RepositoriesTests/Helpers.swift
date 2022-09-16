//
//  Helpers.swift
//  RepositoriesTests
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import XCTest
import Foundation
@testable import Repositories

extension XCTestCase {
    func verify<T>(url: String, in fetchableValue: FetchableValue<T>, file: StaticString = #file, line: UInt = #line) {
        XCTAssertEqual(url, fetchableValue.url.absoluteString, file: file, line: line)
        if case .fetched(_) = fetchableValue.value {
            XCTFail("A decoded FetchableValue should have an unfetched value", file: file, line: line)
        }
    }
    
    func openJsonFile<Model: Decodable>(withName name: String) -> Model? {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            XCTFail("Could not load the data from the file")
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard let model = try? decoder.decode(Model.self, from: data) else {
            XCTFail("Could not decode the JSON data")
            return nil
        }
        return model
    }
}

extension Date {
    init?(string: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self.init(timeIntervalSinceReferenceDate: date.timeIntervalSinceReferenceDate)
    }
}
