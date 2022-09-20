//
//  StateController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 20/09/22.
//

import Foundation

class StateController {
    var user: User? {
        guard var user: User = Loader.loadDataFromJSONFile(withName: "User"),
              let repositories: [Repository] = Loader.loadDataFromJSONFile(withName: "Repositories") else {
            return nil
        }
        user.stars.value = .fetched(value: repositories)
        return user
    }
    
    var users: [User] {
        return Loader.loadDataFromJSONFile(withName: "Users") ?? []
    }
    
    var repository: Repository? {
        guard var repository: Repository = Loader.loadDataFromJSONFile(withName: "Repository") else {
            return nil
        }
        let readMeURL = URL(string: "https://github.com/octokit/octokit.rb/blob/master/README.md")!
        repository.readMe = FetchableValue(url: readMeURL, value: .fetched(value: ""))
        return repository
    }
    
    var repositories: [Repository] {
        return Loader.loadDataFromJSONFile(withName: "Repositories") ?? []
    }
}
