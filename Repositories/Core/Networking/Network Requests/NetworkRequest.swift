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
    func deserialize(_ data: Data?, response: URLResponse?) -> ModelType?
}

extension NetworkRequest {
    func execute(withCompletion completion: @escaping (ModelType?) -> Void) {
        task = session.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            completion( self?.deserialize(data, response: response) )
        }
        task?.resume()
    }
}

// MARK: - JSONDataRequest

protocol JSONDataRequest: NetworkRequest where ModelType: Decodable {}

extension JSONDataRequest {
    func deserialize(_ data: Data?, response: URLResponse?) -> ModelType? {
        guard let data = data else {
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try? decoder.decode(ModelType.self, from: data)
    }
}

// MARK: - HTTPStatusRequest

protocol HTTPStatusRequest: NetworkRequest {}

extension HTTPStatusRequest {
    func deserialize(_ data: Data?, response: URLResponse?) -> Bool? {
        guard let response = response as? HTTPURLResponse else {
            return nil
        }
        switch response.statusCode {
        case 204: return true
        case 404: return false
        default:
            assertionFailure("Unexpected status code")
            return nil
        }
    }
}
