//
//  ChatsProvider.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chats provider
protocol ChatsProvider {
    /// Chat id for new chat
    var newChatId: String? { get }
    
    /// Re-fetches the chat id for new chat.
    func refreshNewChatId()
    
    /// Get list of chats
    /// - Returns: chats array or error
    func getChatsList() async -> Result<[Chat], NetworkError>
    
    /// Get list of chat messages
    /// - Parameter chatId: chat id
    /// - Returns: message array or error
    func getChatMessages(chatId: String) async -> Result<[ChatMessage], NetworkError>
    
}
