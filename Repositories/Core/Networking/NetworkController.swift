//
//  NetworkController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import Foundation

class NetworkController {
    let cachingController = CachingController()
    
    func fetchValue<V: Decodable>(for url: URL) -> V? {
        let cachedValue: CachedValue<V>? = cachingController.fetchValue(for: url)
        return cachedValue?.value
    }
}
