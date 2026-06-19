//
//  ChatService.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Chats API service implementation
final class ChatService: ChatAPI {
    
    private let networkService: NetworkService
    private let tokenStorage: TokenStorage
    
    private lazy var decoder = JSONDecoder()
    
    /// Initialization
    /// - Parameter networkService: network service
    /// - Parameter tokenStorage: token storage
    init(networkService: NetworkService, tokenStorage: TokenStorage) {
        self.networkService = networkService
        self.tokenStorage = tokenStorage
    }
    
    /// Download list of chats
    /// - Returns: chats array or error
    func downloadChatsList() async -> Result<[ChatDTO], NetworkError> {
        // TODO: handle Validation Error from server ? *bug - server return String overwise [ErrorDTO]
        guard let token = tokenStorage.getToken(), let userId = tokenStorage.getUserID() else {
            return .failure(.unAuthorized)
        }
        
        let endpoint = BaseNetworkEndPoint(baseURL: Constants.baseURL + "/chats",
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
                let list = try decoder.decode([ChatDTO].self,
                                              from: data)
                return .success(list)
            } catch {
                return .failure(NetworkError.decodingFailed)
            }
        } catch {
            return .failure(error)
        }
    }
    
}

extension ChatService {
    
    private struct Constants {
        static let baseURL = "https://nebulaapps.site/dola"
        static let appID = "com.test.test"
        static let chatsPageSize = 10
    }
}
