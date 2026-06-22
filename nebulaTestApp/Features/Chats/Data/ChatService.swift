//
//  ChatService.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Combine
import Foundation

/// Chats API service implementation
final class ChatService: ChatAPI {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    /// Chat id for new chat.
    var newChatId: String? {
        newChatIdSubject.value
    }
    /// Holds the current value synchronously (`.value`) and emits updates to subscribers.
    private let newChatIdSubject = CurrentValueSubject<String?, Never>(nil)
    /// Tracks the in-flight fetch task to avoid firing duplicate requests
    /// if a refresh is triggered while one is already running.
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Public methods

    /// Initialization
    /// - Parameter networkService: network service
    /// - Parameter tokenStorage: token storage
    init(networkService: NetworkService, tokenStorage: TokenStorage) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
        refreshNewChatId()
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    /// Download list of chats
    /// - Returns: chats array or error
    func downloadChatsList() async -> Result<[ChatDTO], NetworkError> {
        // TODO: handle Validation Error from server ? *bug - server return String overwise [ErrorDTO]
        guard let token = tokenStorage.getToken(), let userId = tokenStorage.getUserID() else {
            return .failure(.unAuthorized)
        }
        
        let endpoint = BaseNetworkEndPoint(baseURL: Constants.baseURL,
                                           headers: [
                                            "accept": "application/json",
                                            "Authorization": "Bearer " + token
                                           ],
                                           urlParams: [
                                            "limit": "\(Constants.chatsPageSize)",
                                            "offset": "0", // TODO: pagination ?
                                            "user_id": userId,
                                            "app_id": Constants.appID
                                           ])
        do {
            let data = try await networkService.performRequest(endpoint: endpoint)
            
            do {
                let list = try JSONDecoder().decode([ChatDTO].self,
                                                    from: data)
                return .success(list)
            } catch {
                return .failure(NetworkError.decodingFailed)
            }
        } catch {
            return .failure(error)
        }
    }
    
    /// Download list of chat messages
    /// - Parameter chatId: chat id
    /// - Returns: message array or error
    func downloadChatMessages(chatId: String) async -> Result<[ChatMessageDTO], NetworkError> {
        // TODO: handle Validation Error from server ? *bug - server return String overwise [ErrorDTO]
        guard let token = tokenStorage.getToken(), let userId = tokenStorage.getUserID() else {
            return .failure(.unAuthorized)
        }
        
        let endpoint = BaseNetworkEndPoint(baseURL: Constants.baseURL + "/\(chatId)/messages",
                                           headers: [
                                            "accept": "application/json",
                                            "Authorization": "Bearer " + token
                                           ],
                                           urlParams: [
                                            "limit": "\(Constants.messagesPageSize)",
                                            "offset": "0", // TODO: pagination ?
                                            "user_id": userId,
                                            "app_id": Constants.appID
                                           ])
        do {
            let data = try await networkService.performRequest(endpoint: endpoint)
            
            do {
                let list = try JSONDecoder().decode([ChatMessageDTO].self,
                                                    from: data)
                return .success(list)
            } catch {
                return .failure(NetworkError.decodingFailed)
            }
        } catch {
            return .failure(error)
        }
    }
    
    /// Re-fetches the chat id for new chat.
    func refreshNewChatId() {
        guard fetchTask == nil else { return }
        
        fetchTask = Task { [weak self] in
            guard let self else { return }
            
            let newChatID = await self.getNewChatId()
            
            self.newChatIdSubject.send(newChatID)
            self.fetchTask = nil
        }
    }
    
    /// Send user message and get answer
    /// - Parameter chatId: chat id
    /// - Parameter message: message text
    /// - Returns: answer text or error
    func sendMessage(to chatId: String, message: String) async -> Result<String, NetworkError> {
        // TODO: handle Validation Error from server ? *bug - server return String overwise [ErrorDTO]
        guard let token = tokenStorage.getToken(), let userId = tokenStorage.getUserID() else {
            return .failure(.unAuthorized)
        }
        
        let body = SendMessageBody(message: message,
                                   personaId: nil,
                                   additionalPromt: nil)
        var bodyData: Data?
        if let data = try? JSONEncoder().encode(body) {
            bodyData = data
        }
        let endpoint = BaseNetworkEndPoint(baseURL: Constants.baseURL + "/\(chatId)/messages",
                                           headers: [
                                            "accept": "application/json",
                                            "Authorization": "Bearer " + token,
                                            "Content-Type": "application/json"
                                           ],
                                           urlParams: [
                                            "user_id": userId,
                                            "app_id": Constants.appID
                                           ],
                                           params: bodyData,
                                           requestType: .POST)
        do {
            let data = try await networkService.performRequest(endpoint: endpoint)
            
            do {
                let response = try JSONDecoder().decode(SendMessageResponse.self,
                                                        from: data)
                return .success(response.assistantMessage)
            } catch {
                return .failure(NetworkError.decodingFailed)
            }
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private methods
    /// Get chat id for new chat
    /// - Returns: chat id of new chat
    private func getNewChatId() async -> String? { // TODO: how to get chatID for new chat?
        if let chats = try? await self.downloadChatsList().get() {
            let newChatID = chats
                .min(by: { $0.updatedAt < $1.updatedAt })?
                .id
            
            return newChatID
        }
        return nil
    }
}

extension ChatService {
    
    private struct Constants {
        static let baseURL = "https://nebulaapps.site/dola/chats"
        static let appID = "com.test.test"
        static let chatsPageSize = 10
        static let messagesPageSize = 10
    }
}
