//
//  UIStoryboardSegue.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import UIKit

extension UIStoryboardSegue {
    func forward(user: FetchableValue<User>?) {
        func forward(_ user: FetchableValue<User>?, to viewController: UIViewController) {
            (viewController as? EditProfileViewController)?.user = user
            (viewController as? UINavigationController)?.viewControllers.first.map { forward(user, to: $0) }
        }
        
        forward(user, to: destination)
    }
    
    func readUser() -> FetchableValue<User>? {
        return (source as? EditProfileViewController)?.user
    }
}
