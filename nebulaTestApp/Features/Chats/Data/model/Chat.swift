//
//  Chat.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chat data (domain)
struct Chat: Equatable {
    /// Chat id
    let id: String
    /// Title
    let title: String?
    /// Updated date
    let updatedAt: Date
    
    /// Initialization
    /// - Parameters:
    ///   - id: chat id
    ///   - title: title
    ///   - updatedAt: updated date
    init (id: String,
          title: String? = nil,
          updatedAt: Date) {
        self.id = id
        self.title = title
        self.updatedAt = updatedAt
    }
}

/// Chat data transfer object
struct ChatDTO: Codable {
    /// Chat id
    let id: String
    /// Title
    let title: String?
    /// User id
    let personaId: Int?
    /// Updated date
    let updatedAt: String
    /// Last message preview
    let lastMessagePreview: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case title
        case personaId = "persona_id"
        case updatedAt = "updated_at"
        case lastMessagePreview = "last_message_preview"
    }
}
