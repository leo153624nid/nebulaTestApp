//
//  Chat.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chat data (domain)
struct Chat {
    /// Chat id
    let id: String
    /// Title
    let title: String?
}

/// Chat data transfer object
struct ChatDTO: Codable {
    let id: String
    let title: String?
    let personaId: Int?
    let updatedAt: String
    let lastMessagePreview: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "chat_id"
        case title
        case personaId = "persona_id"
        case updatedAt = "updated_at"
        case lastMessagePreview = "last_message_preview"
    }
}
