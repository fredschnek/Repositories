//
//  ImageRequest.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 20/09/22.
//

import UIKit
import Foundation

class ImageRequest {
    let url: URL
    let session: URLSession
    var task: URLSessionDataTask?
    
    init(url: URL, session: URLSession) {
        self.url = url
        self.session = session
    }
}

// MARK: NetworkRequest

extension ImageRequest: NetworkRequest {
    var urlRequest: URLRequest {
        return URLRequest(url: url)
    }
    
    func deserialize(_ data: Data?, response: HTTPURLResponse) throws -> UIImage {
        guard let data = data, let image = UIImage(data: data) else {
            throw NetworkError.unrecoverable
        }
        return image
    }
}
