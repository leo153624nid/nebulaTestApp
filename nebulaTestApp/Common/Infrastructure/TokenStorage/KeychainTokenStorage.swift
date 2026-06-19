//
//  KeychainTokenStorage.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import Foundation

/// Token storage implementation
final class KeychainTokenStorage: TokenStorage {
    
    private enum Keys {
        static let token = "app.token"
        static let userID = "app.userID"
    }
    
    /// Save user credentials
    /// - Parameters:
    ///   - token: token
    ///   - userID: user id
    func save(token: String, userID: String) {
        set(value: token, forKey: Keys.token)
        set(value: userID, forKey: Keys.userID)
    }
    
    /// Get token
    /// - Returns: token (optional)
    func getToken() -> String? {
        get(forKey: Keys.token)
    }
    
    /// Get user id
    /// - Returns: user id (optional)
    func getUserID() -> String? {
        get(forKey: Keys.userID)
    }
    
    /// Clear all
    func clear() {
        delete(forKey: Keys.token)
        delete(forKey: Keys.userID)
    }
    
    // MARK: - Private
    
    private func set(value: String, forKey key: String) {
        guard let data = value.data(using: .utf8) else { return }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let attributes: [CFString: Any] = [
            kSecValueData: data
        ]
        
        if SecItemCopyMatching(query as CFDictionary, nil) == errSecSuccess {
            SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        } else {
            var newItem = query
            newItem[kSecValueData] = data
            SecItemAdd(newItem as CFDictionary, nil)
        }
    }
    
    private func get(forKey key: String) -> String? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        SecItemCopyMatching(query as CFDictionary, &result)
        
        guard let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    private func delete(forKey key: String) {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
