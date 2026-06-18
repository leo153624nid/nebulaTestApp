//
//  ChatAPI.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chats API service
protocol ChatAPI {
    /// Download list of chats
    /// - Returns: chats array or error
    func downloadChatsList() async -> Result<[ChatDTO], NetworkError>
    
}
