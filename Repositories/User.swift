//
//  User.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 16/09/22.
//

import UIKit
import Foundation

struct User {
    let login: String
    let id: Int
    let avatar: UIImage
    var details: Details?
    var repositories: [Repository]?
    var stars: [Repository]?
    var followers: [User]?
    var following: [User]?
    var followed: Bool?
}

// MARK: - Details

extension User {
    struct Details {
        let publicRepositoriesCount: Int
        let followersCount: Int
        let followingCount: Int
        let name: String?
        let company: String?
        let blog: URL?
        let location: String?
        let email: String?
        let bio: String?
    }
}
