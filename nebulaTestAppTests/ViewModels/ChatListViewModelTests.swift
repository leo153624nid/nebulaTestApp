//
//  ChatListViewModelTests.swift
//  nebulaTestAppTests
//
//  Created by A Ch on 26.06.2026.
//

@testable import nebulaTestApp
import XCTest

@MainActor
final class ChatListViewModelTests: XCTestCase {
    
    private var sut: ChatListViewModel!
    private var mockRepository: MockChatsProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mockRepo = MockChatsProvider()
        self.mockRepository = mockRepo
        DIContainer.shared.register(type: ChatsProvider.self, scope: .transient) { _ in
            mockRepo
        }
        sut = ChatListViewModel(coordinator: HomeTabCoordinator(parent: AppRootCoordinator()))
    }

    override func tearDownWithError() throws {
        sut = nil
        mockRepository = nil
        
        try super.tearDownWithError()
    }
    
    func test_perform_onAppear_success() async {
        let expected: [Chat] = [
            Chat(id: "chatId 1",
                 updatedAt: .now)
        ]
        mockRepository.stubbedResult_Chat = .success(expected)
        
        XCTAssertFalse(sut.isLoading)
        
        sut.perform(action: .onAppear)
        
        await Task.yield()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 150_000_000)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertNil(sut.errorMessage)
        XCTAssertEqual(sut.sections.count, expected.count)
        XCTAssertEqual(mockRepository.getChatsListCallCount, 1)
    }
    
    func test_perform_onAppear_failure() async {
        let expected = NetworkError.unknown
        mockRepository.stubbedResult_Chat = .failure(expected)
        
        XCTAssertFalse(sut.isLoading)
        
        sut.perform(action: .onAppear)
        
        await Task.yield()
        await Task.yield()
        try? await Task.sleep(nanoseconds: 150_000_000)
        
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.errorMessage, expected.localizedDescription)
        XCTAssertEqual(sut.sections.count, 0)
        XCTAssertEqual(mockRepository.getChatsListCallCount, 1)
    }
    
}
