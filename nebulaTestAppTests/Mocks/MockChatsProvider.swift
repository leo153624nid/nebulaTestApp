//
//  MockChatsProvider.swift
//  nebulaTestAppTests
//
//  Created by A Ch on 26.06.2026.
//

import Foundation
@testable import nebulaTestApp

final class MockChatsProvider: ChatsProvider {
    
    // Контроль результата из теста
    var stubbedNewChatId: String? = "1"
    var stubbedResult_Chat: Result<[Chat], NetworkError> = .success([])
    var stubbedResult_ChatMessage: Result<[ChatMessage], NetworkError> = .success([])
    var stubbedResult_SendMessage: Result<String, NetworkError> = .success("")
    // Счётчик вызовов для проверки
    var refreshNewChatIdCallCount = 0
    var getChatsListCallCount = 0
    var getChatMessagesCallCount = 0
    var sendMessageCallCount = 0
    
    var newChatId: String? = nil
    
    func refreshNewChatId() {
        refreshNewChatIdCallCount += 1
        newChatId = stubbedNewChatId
    }
    
    func getChatsList() async -> Result<[Chat], NetworkError> {
        getChatsListCallCount += 1
        try? await Task.sleep(nanoseconds: 100_000_000)
        return stubbedResult_Chat
    }
    
    func getChatMessages(chatId: String) async -> Result<[ChatMessage], NetworkError> {
        getChatMessagesCallCount += 1
        try? await Task.sleep(nanoseconds: 100_000_000)
        return stubbedResult_ChatMessage
    }
    
    func sendMessage(to chatId: String, message: String) async -> Result<String, NetworkError> {
        sendMessageCallCount += 1
        try? await Task.sleep(nanoseconds: 100_000_000)
        return stubbedResult_SendMessage
    }
    
}
