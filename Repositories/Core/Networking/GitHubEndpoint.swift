//
//  GitHubEndpoint.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 20/09/22.
//

import Foundation

struct GitHubEndpoint {
    struct FieldNames {
        static let state = "state"
        static let clientID = "client_id"
        static let clientSecret = "client_secret"
        static let authorizationCode = "code"
        static let page = "page"
    }
    
    static let clientID = "1234567890"
    static let clientSecret = "abcdefghijklmnopqrstuvwxyz"
    static let accessTokenURL = URL(string: "https://github.com/login/oauth/access_token")!
}
