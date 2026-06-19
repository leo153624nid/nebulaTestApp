//
//  TokenStorage.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import Foundation

/// Token storage
protocol TokenStorage {
    
    /// Save user credentials
    /// - Parameters:
    ///   - token: token
    ///   - userID: user id
    func save(token: String, userID: String)
    
    /// Get token
    /// - Returns: token (optional)
    func getToken() -> String?
    
    /// Get user id
    /// - Returns: user id (optional)
    func getUserID() -> String?
    
    /// Clear all
    func clear()
}
