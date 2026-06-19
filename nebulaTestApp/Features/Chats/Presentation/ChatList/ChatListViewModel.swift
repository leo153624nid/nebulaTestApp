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
    /// Subscriptions store
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var chatsRepository: ChatsProvider
    
    /// Array of chats
    @Published private(set) var chatList: [Chat] = []
    /// View is loading chat list
    @Published private(set) var isLoading = false
    /// Error message
    @Published private(set) var errorMessage: String?
    
    /// View on screen.
    private var isViewAppeared = false
    
    // MARK: - Initialization
    
    /// Initializator
    ///
    /// - Parameter coordinator: coordinator
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
        setupUpdates()
        getChats()
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
            break // TODO
            
        case .onAppear:
            isViewAppeared = true
            
        case .onDisappear:
            isViewAppeared = false
        }
    }
    
    // MARK: - Private methods
    private func getChats() {
        Task { [weak self] in
            guard let self else { return }
            
            await MainActor.run {
                self.isLoading = true
            }
            
            let result = await chatsRepository.getChatsList()
            
            await MainActor.run {
                guard self.isViewAppeared else { return }
                
                self.isLoading = false
                
                switch result {
                case .success(let chats):
                    self.chatList = chats
                case .failure(let error):
                    print(error) // TODO
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
}

// MARK: - Updates
private extension ChatListViewModel {
    func setupUpdates() {

    }
}
