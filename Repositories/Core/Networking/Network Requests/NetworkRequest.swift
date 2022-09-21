//
//  NetworkRequest.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 20/09/22.
//

import Foundation

// MARK: - NetworkRequest

protocol NetworkRequest: AnyObject {
    associatedtype ModelType
    var urlRequest: URLRequest { get }
    var session: URLSession { get }
    var task: URLSessionDataTask? { get set }
    func deserialize(_ data: Data?, response: HTTPURLResponse) throws -> ModelType
}

extension NetworkRequest {
    func execute(withCompletion completion: @escaping (Result<ModelType>) -> Void) {
        task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard let strongSelf = self else {
                return
            }
            let result = Result { () throws -> ModelType in
                try error?.toNetworkError()
                guard let response = response as? HTTPURLResponse else {
                    throw NetworkError.unrecoverable
                }
                try response.validate()
                return try strongSelf.deserialize(data, response: response)
            }
            completion(result)
        }
        task?.resume()
    }
}

// MARK: - Validable

protocol Validable {
    func validate(_ response: HTTPURLResponse) throws
}

// MARK: - JSONDataRequest

protocol JSONDataRequest: Validable, NetworkRequest where ModelType: Decodable {}

extension JSONDataRequest {
    func deserialize(_ data: Data?, response: HTTPURLResponse) throws -> ModelType {
        guard let data = data else {
            throw NetworkError.unrecoverable
        }
        guard response.statusCode != 404 else {
            throw NetworkError.unrecoverable
        }
        try validate(response)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do { return try decoder.decode(ModelType.self, from: data) }
        catch { throw NetworkError.unrecoverable }
    }
}

// MARK: - HTTPStatusRequest

protocol HTTPStatusRequest: Validable, NetworkRequest {}

extension HTTPStatusRequest {
    func deserialize(_ data: Data?, response: HTTPURLResponse) throws -> Bool {
        try validate(response)
        switch response.statusCode {
        case 204: return true
        case 404: return false
        default:
            assertionFailure("Unexpected status code")
            throw NetworkError.unrecoverable
        }
    }
}
