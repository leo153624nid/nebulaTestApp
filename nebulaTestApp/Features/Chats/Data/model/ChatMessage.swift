//
//  ChatMessage.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import Foundation

/// Chat message data (domain)
struct ChatMessage: Identifiable, Equatable, Sendable {
    /// Message id
    let id = UUID().uuidString
    /// Message text
    let content: String
    /// Role
    let role: Role
    /// Created date
    let createdAt: Date
    
    enum Role: String {
        case user
        case assistant
    }
}

/// Message data transfer object
struct ChatMessageDTO: Codable {
    /// Role
    let role: String
    /// Message text
    let content: String
    /// Message source
    let messageSource: String
    /// Created date
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case role
        case content
        case messageSource = "message_source"
        case createdAt = "created_at"
    }
}
