//
//  Repository.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import Foundation

protocol RepositoryType {}

struct Repository: RepositoryType {
    let id: ID<Repository>
    let name: String
    let isFork: Bool
    let forksCount: Int
    let stargazersCount: Int
    let owner: User
    let updateDate: Date
    let description: String?
    let language: String?
    let parent: RepositoryType?
    var readMe: FetchableValue<String> = FetchableValue(url: URL(string: "http://test.com")!, value: .fetched(value: ""))
    var isStarred: FetchableValue<Bool> = FetchableValue(url: URL(string: "http://test.com")!, value: .fetched(value: false))
}

// MARK: - Decodable

extension Repository: Decodable {
    enum Keys: String, CodingKey {
        case id
        case name
        case description
        case language
        case owner
        case parent
        case updateDate = "updated_at"
        case isFork = "fork"
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        id = try container.value(forKey: .id)
        name = try container.value(forKey: .name)
        isFork = try container.value(forKey: .isFork)
        forksCount = try container.value(forKey: .forksCount)
        stargazersCount = try container.value(forKey: .stargazersCount)
        owner = try container.value(forKey: .owner)
        updateDate = try container.value(forKey: .updateDate)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        parent = try container.decodeIfPresent(Repository.self, forKey: .parent)
    }
}
