//
//  Decoding.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import Foundation

extension URL {
    init?(template: String) {
        let regex = "\\{.*\\}"
        let cleanedString = template.replacingOccurrences(of: regex, with: "", options: .regularExpression)
        self.init(string: cleanedString)
    }
}

extension KeyedDecodingContainer {
    func value<T>(forKey key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        return try decode(T.self, forKey: key)
    }
}
