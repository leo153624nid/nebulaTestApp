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
    /// Last message preview
    let lastMessagePreview: String?
    
    /// Initialization
    /// - Parameters:
    ///   - id: chat id
    ///   - title: title
    ///   - updatedAt: updated date
    ///   - lastMessagePreview: preview last message
    init (id: String,
          title: String? = nil,
          updatedAt: Date,
          lastMessagePreview: String? = nil) {
        self.id = id
        self.title = title
        self.updatedAt = updatedAt
        self.lastMessagePreview = lastMessagePreview
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

// MARK: Mocks
#if DEBUG
extension Chat {
    static let mockList: [Chat] = [
        .init(id: "a1",
              title: "title",
              updatedAt: .now,
              lastMessagePreview: "last message"),
        .init(id: "a2",
              title: "title",
              updatedAt: .now,
              lastMessagePreview: "last message"),
        .init(id: "a3",
              title: nil,
              updatedAt: .daysAgo(1),
              lastMessagePreview: "last message"),
        .init(id: "a4",
              title: nil,
              updatedAt: .daysAgo(1),
              lastMessagePreview: "last message"),
        .init(id: "a5",
              title: nil,
              updatedAt: .daysAgo(7),
              lastMessagePreview: nil),
        .init(id: "a6",
              title: nil,
              updatedAt: .daysAgo(7),
              lastMessagePreview: nil),
        .init(id: "a7",
              title: "title",
              updatedAt: .daysAgo(7),
              lastMessagePreview: "last message"),
        .init(id: "a8",
              title: "title",
              updatedAt: .daysAgo(8),
              lastMessagePreview: "last message"),
    ]
}

extension Date {
    /// Возвращает дату, отстоящую от self на заданное количество дней
    /// - Parameter days: количество дней (отрицательное — в прошлое, положительное — в будущее)
    /// - Returns: новая дата
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }
    
    static func daysAgo(_ days: Int) -> Date {
        Date.now.adding(days: -days)
    }
}
#endif
