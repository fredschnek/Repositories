//
//  KeychainController.swift
//  Repositories
//
//  Created by Frederico Schnekenberg on 21/09/22.
//

import Foundation

class KeychainController {
    private static let accountName = "AppUser"
    
    func readAccessToken() -> String? {
        var query = tokenQuery
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = true
        query[kSecReturnData as String] = true
        var keychainItem: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &keychainItem)
        guard status != errSecItemNotFound else {
            return nil
        }
        guard let item = keychainItem as? [String : Any],
              let data = item[kSecValueData as String] as? Data,
              let token = String(data: data, encoding: .utf8) else {
            return nil
        }
        return token
    }
    
    func store(accessToken: String) {
        let encodedToken = accessToken.data(using: .utf8)!
        var query: [String: Any] = tokenQuery
        if let _ = readAccessToken() {
            SecItemUpdate(query as CFDictionary, [kSecValueData as String: encodedToken] as CFDictionary)
        } else {
            query[kSecValueData as String] = encodedToken
            SecItemAdd(query as CFDictionary, nil)
        }
    }
    
    func deleteAccessToken() {
        SecItemDelete(tokenQuery as CFDictionary)
    }
}

// MARK: Private

private extension KeychainController {
    var tokenQuery: [String: Any] {
        return [
            kSecClass as String: kSecClassInternetPassword,
            kSecAttrAccount as String: KeychainController.accountName,
            kSecAttrServer as String: GitHubEndpoint.serverURL.absoluteString
        ]
    }
}
