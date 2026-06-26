//
//  ChatListViewModelTests2.swift
//  nebulaTestAppTests
//
//  Created by A Ch on 26.06.2026.
//

import Foundation
@testable import nebulaTestApp
import Testing

@Suite("ChatListViewModel")
@MainActor
struct ChatListViewModelTests2 {
    
    private let sut: ChatListViewModel
    private let mockRepository: MockChatsProvider
    
    init() {
        let mockRepo = MockChatsProvider()
        self.mockRepository = mockRepo
        DIContainer.shared.register(type: ChatsProvider.self, scope: .transient) { _ in
            mockRepo
        }
        self.sut = ChatListViewModel(coordinator: HomeTabCoordinator(parent: AppRootCoordinator()))
    }
    
    // MARK: - Начальное состояние

    @Test("Начальное состояние")
    func initialState() {
        #expect(sut.sections.isEmpty)
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
    }
    
    @Test("perform.onAppear.success")
    func test_perform_onAppear_success() async {
        let expected: [Chat] = [
            Chat(id: "chatId 1",
                 updatedAt: .now)
        ]
        mockRepository.stubbedResult_Chat = .success(expected)
        
        #expect(sut.isLoading == false)
        
        sut.perform(action: .onAppear)
        
        try? await Task.sleep(nanoseconds: 150_000_000)
        
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
        #expect(sut.sections.count == expected.count)
        #expect(mockRepository.getChatsListCallCount == 1)
    }
    
    @Test("perform.onAppear.failure")
    func test_perform_onAppear_failure() async {
        let expected = NetworkError.unknown
        mockRepository.stubbedResult_Chat = .failure(expected)
        
        #expect(sut.isLoading == false)
        
        sut.perform(action: .onAppear)
        
        try? await Task.sleep(nanoseconds: 150_000_000)
        
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == expected.localizedDescription)
        #expect(sut.sections.isEmpty)
        #expect(mockRepository.getChatsListCallCount == 1)
    }
    
    @Test("perform.pullToRefresh")
    func test_perform_pullToRefresh() async {
        let expected: [Chat] = [
            Chat(id: "chatId 1",
                 updatedAt: .now)
        ]
        mockRepository.stubbedResult_Chat = .success(expected)
        
        #expect(sut.isLoading == false)
        
        sut.perform(action: .onAppear)

        try? await Task.sleep(nanoseconds: 50_000_000)

        sut.perform(action: .pullToRefresh)
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
        #expect(sut.sections.count == expected.count)
        #expect(mockRepository.getChatsListCallCount == 1)
    }
    
    @Test("perform.onDisappear")
    func test_perform_onDisappear() async {
        let expected: [Chat] = [
            Chat(id: "chatId 1",
                 updatedAt: .now)
        ]
        mockRepository.stubbedResult_Chat = .success(expected)
        
        #expect(sut.isLoading == false)
        
        sut.perform(action: .onAppear)

        try? await Task.sleep(nanoseconds: 50_000_000)

        sut.perform(action: .onDisappear)
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
        #expect(sut.sections.isEmpty)
        #expect(mockRepository.getChatsListCallCount == 1)
    }
    
    @Test("perform.onAppear - double run")
    func test_perform_onAppear_doubleRun() async {
        let expected: [Chat] = [
            Chat(id: "chatId 1",
                 updatedAt: .now)
        ]
        mockRepository.stubbedResult_Chat = .success(expected)
        
        #expect(sut.isLoading == false)
        
        sut.perform(action: .onAppear)

        try? await Task.sleep(nanoseconds: 50_000_000)

        sut.perform(action: .onAppear)
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(sut.isLoading == false)
        #expect(sut.errorMessage == nil)
        #expect(sut.sections.count == expected.count)
        #expect(mockRepository.getChatsListCallCount == 1)
    }
    
}
