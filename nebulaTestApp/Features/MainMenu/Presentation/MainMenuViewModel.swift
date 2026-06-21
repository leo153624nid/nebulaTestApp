//
//  MainMenuViewModel.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Combine
import Foundation
import SwiftUI

/// Actions from MainMenu view
enum MainMenuViewAction {
    case onAppear
    case onDisappear
    case settingsButtonClicked
    case chatButtonClicked
    case videoButtonClicked
    case fixWritingButtonClicked
    case understandButtonClicked
}

/// MainMenu viewModel
final class MainMenuViewModel: ViewModel {
    
    // MARK: - Properties
    /// Own coordinator
    unowned let coordinator: HomeTabCoordinator
    /// Subscriptions store
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var tokenStorage: TokenStorage
    @Injected private var chatsRepository: ChatsProvider
    
    /// View on screen.
    private var isViewAppeared = false
    private var credAlertIsShowed = false
    
    // MARK: - Initialization
    /// Base initializator.
    ///
    /// - Parameter coordinator: coordinator.
    init(coordinator: HomeTabCoordinator) {
        self.coordinator = coordinator
        setupUpdates()
    }
    
    // MARK: - Public methods
    /// Performing actions from view
    ///
    /// - Parameter action: view's action
    func perform(action: MainMenuViewAction) {
        switch action {
        case .onAppear:
            isViewAppeared = true
            actionsAfterAppear()
            
        case .onDisappear:
            isViewAppeared = false
            
        case .settingsButtonClicked:
            break
            
        case .chatButtonClicked:
            guard let chatId = chatsRepository.newChatId else {
                chatsRepository.refreshNewChatId()
                showChatIdErrorAlert()
                return
            }
            let newChat = Chat(id: chatId,
                               title: nil,
                               updatedAt: .now)
            coordinator.openChatScreen(for: newChat)
            
        case .videoButtonClicked:
            break // TODO: update
            
        case .fixWritingButtonClicked:
            break
            
        case .understandButtonClicked:
            break
            
        }
    }
    
    // MARK: - Private methods
    
    private func actionsAfterAppear() {
        showCredentialAlertIfNeeded()
    }
    
//    private func showActivationView(for sectionItem: SectionItem, // TODO
//                                    style: PaywallStyle = .base) {
//        let purchaseItem = PurchaseCoordinatorItem(coordinator: coordinator,
//                                                   source: screenName,
//                                                   style: style) { [weak self] isShown in
//            guard isShown else { return }
//            
//            RPHAnalytics.logMainScreen(from: .activation)
//            
//            if ActivationInfo.isFullVersion {
//                self?.handleSectionItemTapped(sectionItem)
//            }
//        }
//        coordinator.showPurchase(purchaseItem)
//    }
    
    private func showCredentialAlertIfNeeded() {
#if DEBUG
        let token = tokenStorage.getToken()
        let userId = tokenStorage.getUserID()

        if !credAlertIsShowed && (token == "YOUR_TOKEN_HERE" || userId == "YOUR_USER_ID_HERE") {
            let item = AlertItem.setupCredentialsAlertItem { [weak self] in
                self?.credAlertIsShowed = true
            }
            coordinator.showAlert(item)
        }
#endif
    }
    
    private func showChatIdErrorAlert() {
        let item = AlertItem.newChatIdAlertItem()
        coordinator.showAlert(item)
    }
    
}

// MARK: - Setup model
private extension MainMenuViewModel {
    func setupUpdates() {
        
    }
    
}
