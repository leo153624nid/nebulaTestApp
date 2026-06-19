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
}

/// ChatList viewModel
final class ChatListViewModel: ViewModel {
    
    // MARK: - Properties
    /// Own coordinator
    unowned let coordinator: HomeTabCoordinator
    /// Subscriptions store
    private var cancellables = Set<AnyCancellable>()
    
    /// Array of chats
    @Published private(set) var chatList: [Chat] = []
    
    /// View is loading chat list
    @Published private(set) var isLoading = false
    
    // MARK: - Initialization
    
    /// Initializator
    ///
    /// - Parameter coordinator: coordinator
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
        setupUpdates()
    }
    
    // MARK: - Public methods
    /// Performing actions from view
    ///
    /// - Parameter action: view's action
    func perform(action: ChatListViewAction) {
        switch action {
        case .selectChat(let chat):
            break // TODO
            
        case .pullToRefresh:
            break // TODO
        }
    }
    
    // MARK: - Private methods
    
}

// MARK: - Updates
private extension ChatListViewModel {
    func setupUpdates() {
        $isLoading
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
//                    self?.coordinator.showLoadingSplash() // TODO
                } else {
//                    self?.coordinator.hideLoadingSplash() // TODO
                }
            }
            .store(in: &cancellables)
    }
}
