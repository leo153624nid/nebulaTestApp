//
//  ChatsRepository.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chats provider implementation
final class ChatsRepository: ChatsProvider {
    
    private let chatService: ChatAPI
    private let mapper = ChatsMapper()
    
    /// Initialization
    /// - Parameter chatService: chat API
    init(chatService: ChatAPI) {
        self.chatService = chatService
    }
    
    /// Get list of chats
    /// - Returns: chats array or error
    func getChatsList() async -> Result<[Chat], NetworkError> {
        let result = await chatService.downloadChatsList()
        return result.map { mapper.chatsToDomain($0) }
    }
    
}
