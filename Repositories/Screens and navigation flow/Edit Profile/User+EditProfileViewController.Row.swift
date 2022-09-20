//
//  User+EditProfileViewController.Row.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 19/09/22.
//

import Foundation

extension User {
    subscript(row: EditProfileViewController.Row) -> EditProfileViewController.Row {
        let details = self.details.fetchedValue
        switch row {
        case .avatar: return .avatar(#imageLiteral(resourceName: "avatar"))
        case .name: return .name(details?.name ?? "")
        case .blog: return .blog(details?.blog?.absoluteString ?? "")
        case .company: return .company(details?.company ?? "")
        case .location: return .location(details?.location ?? "")
        case .bio: return .bio(details?.bio ?? "")
        }
    }
}
