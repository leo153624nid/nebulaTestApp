//
//  ChatViewModel.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import Combine
import Foundation

/// Actions from Chat view
enum ChatViewAction {
    case sendPromt(text: String)
    case listButtonTapped
}

/// Chat viewModel
final class ChatViewModel: ViewModel {
    
    // MARK: - Properties
    /// Own coordinator
    unowned let coordinator: HomeTabCoordinator
    /// Subscriptions store
    private var cancellables = Set<AnyCancellable>()
    
    /// Chat data
    let chat: Chat
    /// Screen opened from chat list
    let comeFromList: Bool
    
    /// Search text
    @Published var searchText = "" // TODO
    /// View is blocked with loading splash
    @Published private var isViewBlocked = false
    
    // MARK: - Initialization
    
    /// Base initializator
    ///
    /// - Parameter coordinator: coordinator
    convenience init(coordinator: HomeTabCoordinator) {
        self.init(coordinator: coordinator,
                  chat: Chat(id: "TODO", // TODO: how setup chat_id ?
                             updatedAt: .now),
                  comeFromList: false)
    }
    
    /// Initializator
    ///
    /// - Parameter coordinator: coordinator
    /// - Parameter chat: chat data
    /// - Parameter comeFromList: screen opened from chat list
    init(coordinator: HomeTabCoordinator,
         chat: Chat,
         comeFromList: Bool) {
        self.coordinator = coordinator
        self.chat = chat
        self.comeFromList = comeFromList
        setupUpdates()
    }
    
    // MARK: - Public methods
    /// Performing actions from view
    ///
    /// - Parameter action: view's action
    func perform(action: ChatViewAction) {
        switch action {
        case .sendPromt(let text):
            break // TODO
            
        case .listButtonTapped:
            coordinator.openChatListScreen()
        }
    }
    
    // MARK: - Private methods
    
}

// MARK: - Updates
private extension ChatViewModel {
    func setupUpdates() {
//        $searchText // TODO
//            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
//            .removeDuplicates()
//            .receive(on: DispatchQueue.global(qos: .userInitiated))
//            .map { [weak self] query -> [USState] in
//                guard let self else { return [] }
//                guard !query.isEmpty else { return self.states }
//                
//                return self.states.filter {
//                    $0.rawValue.localizedCaseInsensitiveContains(query) ||
//                    $0.shortName.lowercased() == query.lowercased()
//                }
//            }
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] results in
//                self?.results = results
//            }
//            .store(in: &cancellables)
        
        $isViewBlocked
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isViewBlocked in
                if isViewBlocked {
//                    self?.coordinator.showLoadingSplash() // TODO
                } else {
//                    self?.coordinator.hideLoadingSplash() // TODO
                }
            }
            .store(in: &cancellables)
    }
}
