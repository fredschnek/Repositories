//
//  NetworkError.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import Foundation

enum NetworkError: String, LocalizedError {
    case unrecoverable = "NetworkRequest.Error.Unrecoverable"
    case unreachable = "NetworkRequest.Error.Unreachable"
    case unauthorized = "NetworkRequest.Error.Unauthorized"
    case temporary = "NetworkRequest.Error.RetryLater"
    
    var errorDescription: String? {
        return NSLocalizedString(self.rawValue + ".Title", tableName: "NetworkError", comment: "The title for a network error alert")
    }
    
    var recoverySuggestion: String? {
        return NSLocalizedString(self.rawValue + ".Recovery", tableName: "NetworkError", comment: "The description for a network error alert")
    }
}

extension HTTPURLResponse {
    func validate() throws {
        switch statusCode {
        case 400, 402, 403, 405 ..< 500: throw NetworkError.unrecoverable
        case 500 ..< 600: throw NetworkError.temporary
        default: break
        }
    }
}

// MARK: - Error

extension Error {
    func toNetworkError() throws {
        switch self {
        case URLError.cannotConnectToHost,
            URLError.networkConnectionLost,
            URLError.notConnectedToInternet,
            URLError.timedOut:
            throw NetworkError.unreachable
        default: throw NetworkError.unrecoverable
        }
    }
}
