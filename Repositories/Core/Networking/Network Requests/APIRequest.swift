//
//  APIRequest.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 20/09/22.
//

import Foundation

// MARK: - APIRequest

protocol APIRequest: NetworkRequest, Validable {
    var url: URL { get }
    var accessToken: String { get }
}

extension APIRequest {
    var authenticatedURLRequest: URLRequest {
        var request = URLRequest(url: url)
        request.addValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("Repositories", forHTTPHeaderField: "User-Agent")
        return request
    }
    
    func validate(_ response: HTTPURLResponse) throws{
        if response.statusCode == 401 {
            throw NetworkError.unauthorized
        }
    }
}

// MARK: - FetchRequest

class FetchRequest<ModelType: Decodable>: APIRequest, JSONDataRequest {
    let url: URL
    let accessToken: String
    var task: URLSessionDataTask?
    let session: URLSession
    
    init(url: URL, accessToken: String, session: URLSession) {
        self.url = url
        self.accessToken = accessToken
        self.session = session
    }
}

extension FetchRequest: NetworkRequest {
    var urlRequest: URLRequest {
        return authenticatedURLRequest
    }
}

// MARK: - ListRequest

protocol ArrayType {}
extension Array: ArrayType {}

class ListRequest<ModelType: Decodable & ArrayType>: APIRequest, JSONDataRequest {
    let url: URL
    let page: Int
    let accessToken: String
    var task: URLSessionDataTask?
    let session: URLSession
    
    init(url: URL, accessToken: String, session: URLSession, page: Int = 0) {
        self.url = url
        self.accessToken = accessToken
        self.session = session
        self.page = page
    }
}

// MARK: NetworkRequest

extension ListRequest: NetworkRequest {
    var urlRequest: URLRequest {
        var request = authenticatedURLRequest
        guard page > 0 else {
            return request
        }
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [ URLQueryItem(name: GitHubEndpoint.FieldNames.page, value: "\(page)") ]
        request.url = urlComponents.url!
        return request
    }
}

// MARK: - UpdateRequest

class UpdateRequest<UpdateType: Encodable, ModelType: Decodable>: APIRequest, JSONDataRequest {
    let url: URL
    let accessToken: String
    let value: UpdateType
    var task: URLSessionDataTask?
    let session: URLSession
    
    init(url: URL, accessToken: String, session: URLSession, value: UpdateType) {
        self.url = url
        self.accessToken = accessToken
        self.session = session
        self.value = value
    }
}

extension UpdateRequest: NetworkRequest {
    var urlRequest: URLRequest {
        var request = authenticatedURLRequest
        request.httpMethod = "PATCH"
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try? encoder.encode(value)
        return request
    }
}

// MARK: - StatusRequest

class StatusRequest: APIRequest, HTTPStatusRequest {
    let url: URL
    let accessToken: String
    let session: URLSession
    var task: URLSessionDataTask?
    
    init(url: URL, accessToken: String, session: URLSession) {
        self.url = url
        self.accessToken = accessToken
        self.session = session
    }
}

extension StatusRequest: NetworkRequest {
    var urlRequest: URLRequest {
        return authenticatedURLRequest
    }
}

// MARK: - CheckRequest

class ToggleRequest: APIRequest, HTTPStatusRequest {
    let url: URL
    let accessToken: String
    let session: URLSession
    let isChecked: Bool
    var task: URLSessionDataTask?
    
    init(url: URL, accessToken: String, session: URLSession, isChecked: Bool = true) {
        self.url = url
        self.accessToken = accessToken
        self.session = session
        self.isChecked = isChecked
    }
}

extension ToggleRequest: NetworkRequest {
    var urlRequest: URLRequest {
        var request = authenticatedURLRequest
        request.httpMethod = isChecked ? "PUT" : "DELETE"
        return request
    }
}
