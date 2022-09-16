//
//  Repository.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import Foundation

protocol RepositoryType {}

struct Repository: RepositoryType {
    let id: Int
    let name: String
    let isFork: Bool
    let forksCount: Int
    let stargazersCount: Int
    let owner: User
    let updateDate: Date
    let description: String?
    let language: String?
    let parent: RepositoryType?
    var readMe: String?
    var starred: Bool?
}
