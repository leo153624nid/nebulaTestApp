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
    case sendMessage
    case listButtonTapped
    case onAppear
    case onDisappear
}

/// Chat viewModel
final class ChatViewModel: ViewModel { // TODO: handle sending, add paginating
    
    // MARK: - Properties
    /// Own coordinator
    unowned let coordinator: HomeTabCoordinator
    /// Subscriptions store
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var chatsRepository: ChatsProvider
    
    /// Chat data
    let chat: Chat
    /// Screen opened from chat list
    let comeFromList: Bool
    
    /// Array of messages
    @Published private(set) var messages: [ChatMessage] = []
    /// Input text
    @Published var inputText = ""
    /// History of messages is loading
    @Published private(set) var isLoading = false
    /// Message is sending
    @Published private(set) var isSending = false
    /// Error text
    @Published private(set) var errorMessage: String?
    
    /// View on screen.
    private var isViewAppeared = false
    
    // MARK: - Initialization
    
    /// Base initializator
    ///
    /// - Parameter coordinator: coordinator
    convenience init(coordinator: HomeTabCoordinator) {
        self.init(coordinator: coordinator,
                  chat: Chat(id: "no chat id",
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
        loadHistory()
    }
    
    // MARK: - Public methods
    /// Performing actions from view
    ///
    /// - Parameter action: view's action
    func perform(action: ChatViewAction) {
        switch action {
        case .onAppear:
            isViewAppeared = true
            
        case .onDisappear:
            isViewAppeared = false
            
        case .sendMessage:
            sendMessage()
            
        case .listButtonTapped:
            coordinator.openChatListScreen()
        }
    }
    
    // MARK: - Private methods
    private func loadHistory() {
        guard !isLoading else { return }
        
        Task { [weak self] in
            guard let self else { return }
            
            await MainActor.run {
                self.isLoading = true
            }
            
            let result = await chatsRepository.getChatMessages(chatId: chat.id)
            
            await MainActor.run {
                guard self.isViewAppeared else { return }
                
                switch result {
                case .success(let messages):
                    self.messages = messages
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                
                self.isLoading = false
            }
        }
    }
    
    private func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !isSending else { return }
        
        Task { [weak self] in
            guard let self else { return }
            
            let userMessage = ChatMessage(content: text,
                                          role: .user,
                                          createdAt: .now)
            await MainActor.run {
                self.messages.append(userMessage)
                self.inputText = ""
                self.isSending = true
                self.errorMessage = nil
            }
            
            let result = await chatsRepository.sendMessage(to: chat.id,
                                                           message: text)
            
            await MainActor.run {
                guard self.isViewAppeared else { return }
                
                switch result {
                case .success(let answer):
                    self.messages.append(
                        ChatMessage(content: answer,
                                    role: .assistant,
                                    createdAt: .now)
                    )
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
                
                self.isSending = false
            }
        }
    }
    
}

// MARK: - Updates
private extension ChatViewModel { // TODO
    func setupUpdates() {
//        $searchText
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
        
//        $isViewBlocked
//            .removeDuplicates()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] isViewBlocked in
//                if isViewBlocked {
//                    self?.coordinator.showLoadingSplash()
//                } else {
//                    self?.coordinator.hideLoadingSplash()
//                }
//            }
//            .store(in: &cancellables)
    }
    
}
