//
//  ModelTypes.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import Foundation

struct ID<T> {
    let value: Int
}

extension ID: Decodable {
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer().decode(Int.self)
        self.init(value: value)
    }
}

struct FetchableValue<T> {
    let url: URL
    var value: RemoteValue<T>
    
    enum RemoteValue<T> {
        case notFetched
        case fetched(value: T)
    }
}

extension FetchableValue: Decodable {
    init(from decoder: Decoder) throws {
        let template = try decoder.singleValueContainer().decode(String.self)
        guard let url = URL(template: template) else {
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: ""))
        }
        self.url = url
        value = .notFetched
    }
}
