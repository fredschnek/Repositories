//
//  Result.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import Foundation

enum Result<Wrapped> {
    case failure(Error)
    case success(Wrapped)
    
    init(closure: () throws -> Wrapped) {
        do { self = .success(try closure()) }
        catch { self = .failure(error) }
    }
    
    func get() throws -> Wrapped {
        switch self {
        case let .success(value): return value
        case let .failure(error): throw error
        }
    }
}
