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
    
    @Injected private var chatsRepository: ChatsProvider

    /// Sections and items of sections for view
    @Published private(set) var sections = [Section]()
    /// TODO
    @Published private(set) var isLoading = false
    
    /// View on screen.
    private var isViewAppeared = false
    
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
            break // TODO
            
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
        
        getChats() // TODO: here ?
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
                    print(chats) // TODO
                case .failure(let error):
                    print(error) // TODO
                }
            }
        }
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
