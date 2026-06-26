//
//  ChatListViewModel.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import Combine
import Foundation

/// Actions from ChatList view
enum ChatListViewAction {
    case selectChat(Chat)
    case pullToRefresh
    case onAppear
    case onDisappear
}

/// ChatList viewModel
final class ChatListViewModel: ViewModel { // TODO: add paginating
    
    // MARK: - Properties
    /// Own coordinator
    unowned let coordinator: HomeTabCoordinator
    
    @Injected private var chatsRepository: ChatsProvider
    
    /// Array of section with grouped chats
    @Published private(set) var sections: [ChatSection] = []
    /// View is loading chat list
    @Published private(set) var isLoading = false
    /// Error message
    @Published private(set) var errorMessage: String?
    
    private var chatList: [Chat] = []
    private var groupingTask: Task<Void, Never>?
    /// View on screen.
    private var isViewAppeared = false
    
    // MARK: - Initialization
    
    /// Initializator
    ///
    /// - Parameter coordinator: coordinator
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - Public methods
    /// Performing actions from view
    ///
    /// - Parameter action: view's action
    func perform(action: ChatListViewAction) {
        switch action {
        case .selectChat(let chat):
            coordinator.openChatScreen(for: chat)
            
        case .pullToRefresh:
            getChats()
            
        case .onAppear:
            isViewAppeared = true
            getChats()
            
        case .onDisappear:
            isViewAppeared = false
        }
    }
    
    // MARK: - Private methods
    private func getChats() {
        Task { [weak self] in
            guard let self, !isLoading else { return }
            
            self.isLoading = true
            
            let result = await chatsRepository.getChatsList()
            
            guard self.isViewAppeared else {
                self.isLoading = false
                return
            }
            
            switch result {
            case .success(let chats):
                self.setupChats(with: chats)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            
            self.isLoading = false
        }
    }
    
    private func setupChats(with newChats: [Chat]) {
        chatList = newChats
        
        groupingTask?.cancel()
        groupingTask = Task.detached(priority: .userInitiated) { [weak self] in
            guard let self, !Task.isCancelled else { return }
            
            let grouped = Self.groupedAndSorted(newChats)
            
            guard !Task.isCancelled else { return }
            
            await MainActor.run {
                self.sections = grouped
            }
        }
    }
    
}

// MARK: - Setup Data
extension ChatListViewModel {
    
    struct ChatSection: Identifiable, Equatable {
        let id: Date // дата уникальна для секции, годится как id
        let chats: [Chat]
    }
    
    nonisolated private static func groupedAndSorted(_ chats: [Chat]) -> [ChatSection] {
        let grouped = Dictionary(grouping: chats) {
            Calendar.current.startOfDay(for: $0.updatedAt)
        }
        
        return grouped
            .map { date, chats in
                ChatSection(id: date,
                            chats: chats.sorted { $0.updatedAt > $1.updatedAt })
            }
            .sorted { $0.id > $1.id }
    }
}
