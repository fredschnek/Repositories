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
        static let scope = "scope"
    }
    
    static let clientID = "1234567890"
    static let clientSecret = "abcdefghijklmnopqrstuvwxyz"
    static let scope = "user"
    static let authorizationCallbackURLScheme = "repositories://oauth"
    static let accessTokenURL = URL(string: "https://github.com/login/oauth/access_token")!
    static let serverURL = URL(string: "https://github.com")!
    static let authorizationURL = URL(string: "https://github.com/login/oauth/authorize")!
    static let signOutURL = URL(string: "https://github.com/logout")!
    static let apiRootURL = URL(string: "https://api.github.com")!
    
    
    static var updateUserURL: URL {
        return apiRootURL.appendingPathComponent("/user")
    }
    
    static func authorizationUrl(with state: String) -> URL {
        var urlComponents = URLComponents(url: GitHubEndpoint.authorizationURL, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: FieldNames.clientID, value: GitHubEndpoint.clientID),
            URLQueryItem(name: FieldNames.state, value: state),
            URLQueryItem(name: FieldNames.scope, value: GitHubEndpoint.scope)
        ]
        return urlComponents.url!
    }
    
    static func followURL(for user: User) -> URL {
        return apiRootURL
            .appendingPathComponent("user")
            .appendingPathComponent("following")
            .appendingPathComponent(user.login)
    }
}

// MARK: - URL

extension URL {
    var authorizationCode: String? {
        guard absoluteString.contains(GitHubEndpoint.authorizationCallbackURLScheme) else {
            return nil
        }
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        for queryItem in queryItems {
            if queryItem.name == GitHubEndpoint.FieldNames.authorizationCode {
                return queryItem.value
            }
        }
        return nil
    }
}

// MARK: - GitHubRoot

struct GitHubRoot: Decodable {
    enum CodingKeys: String, CodingKey {
        case user = "current_user_url"
        case repositories = "current_user_repositories_url"
        case stars = "starred_url"
        case followers = "followers_url"
        case following = "following_url"
    }
    
    let user: FetchableValue<User>
    let repositories: FetchableValue<[Repository]>
    let stars: FetchableValue<[Repository]>
    let followers: FetchableValue<[User]>
    let following: FetchableValue<[User]>
}
