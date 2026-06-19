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
    
    /// Initialization
    /// - Parameter networkService: network service
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Download list of chats
    /// - Returns: chats array or error
    func downloadChatsList() async -> Result<[ChatDTO], NetworkError> { // TODO: handle Validation Error from server
        let endpoint = BaseNetworkEndPoint(baseURL: Constants.baseURL + "/chats",
                                           headers: [
                                            "accept": "application/json",
                                            "Authorization": "Bearer " + Constants.token // TODO: from Keychain
                                           ],
                                           urlParams: [
                                            "limit": "\(Constants.chatsPageSize)",
                                            "offset": "0", // TODO: pagination ?
                                            "user_id": Constants.userID, // TODO: from Keychain
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
    
}

extension ChatService {
    
    private struct Constants {
        static let baseURL = "https://nebulaapps.site/dola"
        static let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJzaGFyb3ZfMTk5OUBsaXN0LnJ1Iiwicm9sZSI6IkFETUlOIiwiZXhwIjo0OTM1MjA4NjcxLCJpYXQiOjE3ODE2MDg2NzEsInR5cGUiOiJhY2Nlc3MifQ.0GRnZq1LZA__0G0tYEsPER8lQiCiX_myE6_T_nMwUmc" // TODO: store in Keychain
        static let userID = "ApphudUserID" // TODO: store in Keychain
        static let appID = "com.test.test"
        static let chatsPageSize = 10
    }
}
