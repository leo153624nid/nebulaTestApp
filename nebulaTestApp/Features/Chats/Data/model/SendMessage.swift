//
//  SendMessage.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import Foundation

/// Message body for sending
struct SendMessageBody: Codable {
    /// Message text
    let message: String
    /// Persona id
    let personaId: Int?
    /// Additional promt
    let additionalPromt: String?
    
    enum CodingKeys: String, CodingKey {
        case message
        case personaId = "persona_id"
        case additionalPromt = "additional_promt"
    }
}

/// Sending message response
struct SendMessageResponse: Codable {
    /// Chat id
    let chatId: String
    /// Answer text
    let assistantMessage: String
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case assistantMessage = "assistant_message"
    }
}
