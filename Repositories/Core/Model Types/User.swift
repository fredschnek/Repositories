//
//  User.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import Foundation
import UIKit

struct User {
    let login: String
    let id: ID<User>
    var avatar: FetchableValue<UIImage>
    var repositories: FetchableValue<[Repository]>
    var stars: FetchableValue<[Repository]>
    var followers: FetchableValue<[User]>
    var following: FetchableValue<[User]>
    var isFollowed: FetchableValue<Bool> = FetchableValue(url: URL(string: "http://test.com")!, value: .fetched(value: false))
    var details: FetchableValue<Details>
}

// MARK: Decodable

extension User: Decodable {
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case url
        case avatarUrl = "avatar_url"
        case repositoriesUrl = "repos_url"
        case starredUrl = "starred_url"
        case followersUrl = "followers_url"
        case followingUrl = "following_url"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        login = try container.value(forKey: .login)
        id = try container.value(forKey: .id)
        avatar = try container.value(forKey: .avatarUrl)
        repositories = try container.value(forKey: .repositoriesUrl)
        stars = try container.value(forKey: .starredUrl)
        followers = try container.value(forKey: .followersUrl)
        following = try container.value(forKey: .followingUrl)
        
        func decodeDetails() throws -> FetchableValue<Details> {
            let detailsContainer = try decoder.container(keyedBy: Details.CodingKeys.self)
            guard detailsContainer.contains(.publicRepositoriesCount) else {
                return try container.decode(FetchableValue.self, forKey: .url)
            }
            let details = try Details(from: decoder)
            return FetchableValue(url: try container.value(forKey: .url), value: .fetched(value: details))
        }
        
        details = try decodeDetails()
    }
}

// MARK: - Details

extension User {
    struct Details: Decodable {
        let publicRepositoriesCount: Int
        let followersCount: Int
        let followingCount: Int
        let name: String?
        let company: String?
        let location: String?
        let email: String?
        let bio: String?
        let blog: URL?
    }
}

extension User.Details {
    enum CodingKeys: String, CodingKey {
        case name
        case company
        case blog
        case location
        case email
        case bio
        case publicRepositoriesCount = "public_repos"
        case followersCount = "followers"
        case followingCount = "following"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        publicRepositoriesCount = try container.value(forKey: .publicRepositoriesCount)
        followersCount = try container.value(forKey: .followersCount)
        followingCount = try container.value(forKey: .followingCount)
        name = try container.value(forKey: .name)
        company = try container.value(forKey: .company)
        location = try container.value(forKey: .location)
        email = try container.value(forKey: .email)
        bio = try container.value(forKey: .bio)
        let blog: String = try container.value(forKey: .blog)
        self.blog = blog.isEmpty ? nil : URL(string: blog)
    }
    
}

// MARK: - UserUpdate

struct UserUpdate: Encodable {
    var name: String?
    var blog: String?
    var company: String?
    var location: String?
    var bio: String?
}
