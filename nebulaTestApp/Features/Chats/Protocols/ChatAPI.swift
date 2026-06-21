//
//  ChatAPI.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chats API service
protocol ChatAPI {
    /// Chat id for new chat
    var newChatId: String? { get }
    
    /// Re-fetches the chat id for new chat.
    func refreshNewChatId()
    
    /// Download list of chats
    /// - Returns: chats array or error
    func downloadChatsList() async -> Result<[ChatDTO], NetworkError>
    
    /// Download list of chat messages
    /// - Parameter chatId: chat id
    /// - Returns: message array or error
    func downloadChatMessages(chatId: String) async -> Result<[ChatMessageDTO], NetworkError>
    
}
