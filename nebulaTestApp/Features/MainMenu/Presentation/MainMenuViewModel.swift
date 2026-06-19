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
    case sectionItemTapped(MainMenuViewModel.SectionItem)
    case onAppear
    case onDisappear
}

/// MainMenu viewModel
final class MainMenuViewModel: ViewModel {
    
    // MARK: - Properties
    /// Own coordinator
    unowned let coordinator: HomeTabCoordinator
    /// Subscriptions store
    private var cancellables = Set<AnyCancellable>()
    
    @Injected private var tokenStorage: TokenStorage

    /// Sections and items of sections for view
    @Published private(set) var sections = [Section]()
    
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
        reloadSections()
    }
    
    // MARK: - Public methods
    /// Performing actions from view
    ///
    /// - Parameter action: view's action
    func perform(action: MainMenuViewAction) {
        switch action {
        case .sectionItemTapped(let item):
            handleSectionItemTapped(item)
            
        case .onAppear:
            isViewAppeared = true
            actionsAfterAppear()
            
        case .onDisappear:
            isViewAppeared = false
            
        }
    }
    
    // MARK: - Private methods
    private func handleSectionItemTapped(_ item: SectionItem) {
        switch item {
        case .learning:
            let mock = Chat(id: "mockId1",
                            title: "title?",
                            updatedAt: .now)
            coordinator.openChatScreen(for: mock) // TODO: where find new chatID ?
            
        case .exam:
            break // TODO

        }
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
    
    private func actionsAfterAppear() {
        reloadSections()
        showCredentialAlertIfNeeded()
    }
    
    private func reloadSections() { // TODO
        var sections = [Section]()
        
        sections.append(
            .init(identifier: .main,
                  items: [.learning,
                          .exam]
                 )
        )
        sections.append(
            .init(identifier: .more,
                  items: []
                 )
        )
        
        self.sections = sections
    }
    
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
    
}

// MARK: - Sections data
extension MainMenuViewModel {
    
    /// Section of MainMenu view
    struct Section: Equatable {
        enum Identifier {
            case main
            case survey
            case more
        }
        
        /// Identifier.
        let identifier: Identifier
        /// Items of section.
        let items: [SectionItem]
        
        /// A flag that means that the section has both vertical cells
        var hasTwoVerticalCells: Bool {
            return false // TODO
        }
        
        /// A list of two vertical cells for section
        var verticalSectionItems: [SectionItem] {
            return [] // TODO
        }
        
        /// Section header
        var header: String? {
            switch identifier {
            case .more: Str.Common.language // TODO
            default: nil
            }
        }
    }
    
    /// Section item of MainMenu view
    enum SectionItem: Int {
        case learning = 0
        case exam
        
        /// Text in title of item view
        var title: String {
            switch self {
            case .learning: Str.Common.appName // TODO
            case .exam: "exam"
            default: ""
            }
        }
        
        /// Text in subtitle of item view
        var subTitle: String? {
            switch self {
            default: nil
            }
        }
        
        /// Resource name for icon in item view
        var asset: ImageAsset {
            switch self {
            default: .init(name: "")
            }
        }
    }
    
}

// MARK: - Setup model
private extension MainMenuViewModel {
    func setupUpdates() {
        
    }
    
}
