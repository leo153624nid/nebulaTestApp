//
//  ChatsMapper.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chat objects mapper
struct ChatsMapper {
    /// Convert chat dto to domain
    /// - Parameter dto: chat dto
    /// - Returns: chat domain
    func chatToDomain(_ dto: ChatDTO) -> Chat {
        return Chat(id: dto.id,
                    title: dto.title,
                    updatedAt: isoStringToDate(dto.updatedAt) ?? .now,
                    lastMessagePreview: dto.lastMessagePreview)
    }
    
    /// Convert array of chat dto to domain
    /// - Parameter dto: array chat dto
    /// - Returns: array chat domain
    func chatsToDomain(_ dtos: [ChatDTO]) -> [Chat] {
        dtos.map(chatToDomain)
    }
    
    /// Convert message dto to domain
    /// - Parameter dto: message dto
    /// - Returns: message domain
    func messageToDomain(_ dto: ChatMessageDTO) -> ChatMessage {
        return ChatMessage(content: dto.content,
                           role: .init(rawValue: dto.role) ?? .assistant,
                           createdAt: isoStringToDate(dto.createdAt) ?? .now)
    }
    
    /// Convert array of message dto to domain
    /// - Parameter dto: array message dto
    /// - Returns: array message domain
    func messagesToDomain(_ dtos: [ChatMessageDTO]) -> [ChatMessage] {
        dtos.map(messageToDomain)
    }
    
    /// ISO string convert to Date
    /// - Parameter isoString: ISO string
    /// - Returns: date (optional)
    private func isoStringToDate(_ isoString: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: isoString) {
            return date
        }
        
        // Fallback без дробных секунд
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: isoString)
    }
    
}
