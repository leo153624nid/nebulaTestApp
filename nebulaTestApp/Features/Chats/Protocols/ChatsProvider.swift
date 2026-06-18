//
//  ChatsProvider.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chats provider
protocol ChatsProvider {
    
    /// Get list of chats
    /// - Returns: chats array or error
    func getChatsList() async -> Result<[Chat], NetworkError> // TODO: map to UI message ?
}
