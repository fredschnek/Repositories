//
//  NetworkController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 17/09/22.
//

import UIKit
import Foundation

class NetworkController {
    private let cachingController: CachingController
    private let keychainController: KeychainController
    private let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
    private var requests: [URL: AnyObject] = [:]
    
    init(keychainController: KeychainController, cachingController: CachingController) {
        self.keychainController = keychainController
        self.cachingController = cachingController
    }
    
    var accessToken: String? {
        return keychainController.readAccessToken()
    }
    
    var isClientAuthenticated: Bool {
        return accessToken != nil
    }
    
    func authenticateWith(authorizationCode: String, state: String, completion: @escaping () -> Void) {
        let accessTokenRequest = AccessTokenRequest(authorizationCode: authorizationCode, state: state)
        let requestURL = accessTokenRequest.urlRequest.url!
        requests[requestURL] = accessTokenRequest
        accessTokenRequest.execute { (authorization) in
            if let accessToken = authorization?.accessToken {
                self.keychainController.store(accessToken: accessToken)
            }
            self.requests[requestURL] = nil
            completion()
        }
    }
    
    func fetchImage(for url: URL, withCompletion completion: @escaping (UIImage?) -> Void) {
        let imageRequest = ImageRequest(url: url, session: session)
        requests[url] = imageRequest
        imageRequest.execute { [weak self] image in
            self?.requests[url] = nil
            completion(image)
        }
    }
    
    func fetchValue<V: Decodable>(for url: URL, withCompletion completion: @escaping (V?) -> Void) {
        guard let accessToken = accessToken else {
            completion(nil)
            return
        }
        let apiRequest = FetchRequest<V>(url: url, accessToken: accessToken, session: session)
        requests[url] = apiRequest
        apiRequest.execute { [weak self] value in
            completion(value)
            self?.requests[url] = nil
        }
    }
    
    func fetchValue<V: Codable>(for url: URL, withCompletion completion: @escaping (V?) -> Void) {
        let cachedValue: CachedValue<V>? = cachingController.fetchValue(for: url)
        if let cachedValue = cachedValue, !cachedValue.isStale {
            completion(cachedValue.value)
            return
        }
        guard let accessToken = accessToken else {
            completion(cachedValue?.value)
            return
        }
        let apiRequest = FetchRequest<V>(url: url, accessToken: accessToken, session: session)
        requests[url] = apiRequest
        apiRequest.execute { [weak self] value in
            self?.requests[url] = nil
            guard let value = value else {
                completion(cachedValue?.value)
                return
            }
            self?.cachingController.store(value: value, for: url)
            completion(value)
        }
    }
    
    func submit<V: Encodable, U: Decodable>(value: V, toURL url: URL, withCompletion completion: @escaping (U?) -> Void) {
        guard let accessToken = accessToken else {
            completion(nil)
            return
        }
        let updateRequest = UpdateRequest<V, U>(url: url, accessToken: accessToken, session: session, value: value)
        requests[url] = updateRequest
        updateRequest.execute { [weak self] value in
            self?.requests[url] = nil
            completion(value)
        }
    }
    
    func logOut() {
        keychainController.deleteAccessToken()
    }
}
