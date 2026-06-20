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
    
    /// ISO string convert to Date
    /// - Parameter isoString: ISO string
    /// - Returns: date (optional)
    func isoStringToDate(_ isoString: String) -> Date? {
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
