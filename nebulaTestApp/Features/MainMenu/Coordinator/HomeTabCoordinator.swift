//
//  HomeTabCoordinator.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Combine
import Foundation
import SwiftUI

/// Home tab coordinator
final class HomeTabCoordinator: Coordinator {
    // MARK: - Properties
    
    /// Parent coodinator.
    unowned let parent: AppRootCoordinator
    /// Own ViewModel.
    @Published var rootViewModel: MainMenuViewModel!
    /// User flow.
    @Published var path = [Path]()
    /// Navigation is disabled.
    @Published var isNavigationDisabled = false
    
    // MARK: - Initialization
    
    /// Initialization.
    ///
    /// - Parameter parent: parent coordinator.
    init(parent: AppRootCoordinator) {
        self.parent = parent
        self.rootViewModel = MainMenuViewModel(coordinator: self)
    }
    
    // MARK: - Navigation

    /// Replace top screen.
    ///
    /// - Parameter oldPath: current screen.
    /// - Parameter newPath: new screen.
    private func replaceTopPath(_ oldPath: Path, with newPath: Path) {
        let isReplace = oldPath == path.last
        
        path.append(newPath)
        
        if isReplace {
            isNavigationDisabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) {
                let count = self.path.count
                guard count > 1 else {
                    self.isNavigationDisabled = false
                    return
                }
                
                UIView.setAnimationsEnabled(false)
                
                let index = count - 2
                if oldPath == self.path[index] {
                    self.path.remove(at: index)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                    UIView.setAnimationsEnabled(true)
                    self.isNavigationDisabled = false
                }
            }
        }
    }

    /// Open previous screen.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Open root screen.
    func popToRoot() {
        path.removeAll()
    }
    
}

extension HomeTabCoordinator {
    /// Screens for navigation.
    @MainActor
    enum Path: Hashable {
        case chat(context: FlowModelContext<ChatViewModel>)
        case chatList(context: FlowModelContext<ChatListViewModel>)
    }
}

// MARK: Chats
extension HomeTabCoordinator {
    
    /// Open screen of chat.
    /// - Parameter chat: chat data
    func openChatScreen(for chat: Chat) {
        let item = HomeTabCoordinator.Path.chat(
            context: FlowModelContext(model: ChatViewModel(coordinator: self,
                                                           chat: chat))
        )
        path.append(item)
    }
    
    /// Open screen of chat list.
    func openChatListScreen() {
        let item = HomeTabCoordinator.Path.chatList(
            context: FlowModelContext(model: ChatListViewModel(coordinator: self))
        )
        path.append(item)
    }
    
}
