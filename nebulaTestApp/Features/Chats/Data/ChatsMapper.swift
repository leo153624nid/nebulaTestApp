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
                    title: dto.title)
    }
    
    /// Convert array of chat dto to domain
    /// - Parameter dto: array chat dto
    /// - Returns: array chat domain
    func chatsToDomain(_ dtos: [ChatDTO]) -> [Chat] {
        dtos.map(chatToDomain)
    }
}
