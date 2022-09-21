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
    
    func authenticateWith(authorizationCode: String, state: String, completion: @escaping (Result<Void>) -> Void) {
        let accessTokenRequest = AccessTokenRequest(authorizationCode: authorizationCode, state: state)
        let requestURL = accessTokenRequest.urlRequest.url!
        requests[requestURL] = accessTokenRequest
        accessTokenRequest.execute { [weak self] (result) in
            self?.requests[requestURL] = nil
            let result = Result {
                let authorization = try result.get()
                self?.keychainController.store(accessToken: authorization.accessToken)
            }
            completion(result)
        }
    }
    
    func fetchImage(for url: URL, withCompletion completion: @escaping (Result<UIImage>) -> Void) {
        let imageRequest = ImageRequest(url: url, session: session)
        requests[url] = imageRequest
        imageRequest.execute { [weak self] result in
            self?.requests[url] = nil
            completion(result)
        }
    }
    
    func fetchValue<V: Decodable>(for url: URL, withCompletion completion: @escaping (Result<V>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        let apiRequest = FetchRequest<V>(url: url, accessToken: accessToken, session: session)
        requests[url] = apiRequest
        apiRequest.execute { [weak self] result in
            completion(result)
            self?.requests[url] = nil
        }
    }
    
    func submit<V: Encodable, U: Decodable>(value: V, toURL url: URL, withCompletion completion: @escaping (Result<U>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        let updateRequest = UpdateRequest<V, U>(url: url, accessToken: accessToken, session: session, value: value)
        requests[url] = updateRequest
        updateRequest.execute { [weak self] result in
            self?.requests[url] = nil
            completion(result)
        }
    }
    
    func checkStatus(for url: URL, withCompletion completion: @escaping (Result<Bool>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        let statusRequest = StatusRequest(url: url, accessToken: accessToken, session: session)
        requests[url] = statusRequest
        statusRequest.execute { [weak self] result in
            self?.requests[url] = nil
            completion(result)
        }
    }
    
    func toggle(status: Bool, forURL url: URL, withCompletion completion: @escaping (Result<Bool>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        let toggleRequest = ToggleRequest(url: url, accessToken: accessToken, session: session, isChecked: status)
        requests[url] = toggleRequest
        toggleRequest.execute { [weak self] result in
            self?.requests[url] = nil
            completion(result)
        }
    }
    
    func fetchList<A: Decodable & ArrayType>(for url: URL, page: Int, withCompletion completion: @escaping (Result<A>) -> Void) {
        guard let accessToken = accessToken else {
            completion(.failure(NetworkError.unauthorized))
            return
        }
        let listRequest = ListRequest<A>(url: url, accessToken: accessToken, session: session, page: page)
        requests[url] = listRequest
        listRequest.execute { [weak self] result in
            self?.requests[url] = nil
            completion(result)
        }
    }
    
    func logOut() {
        keychainController.deleteAccessToken()
    }
}
