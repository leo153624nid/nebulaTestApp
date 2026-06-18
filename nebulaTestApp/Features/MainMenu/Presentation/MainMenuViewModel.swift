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

    /// Sections and items of sections for view
    @Published private(set) var sections = [Section]()
    
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
    }
    
    private func reloadSections() {
        var sections = [Section]()
        
        sections.append(
            .init(identifier: .main,
                  items: [.learning,
                          .modes,
                          .hazard,
                          MainLocalBannersUtil.shared.canShowReviewCell ? .review : nil,
                          MainLocalBannersUtil.shared.canShowSaleCell ? .sale : nil,
                          .exam,
                          .videoTips].compactMap({ $0 })
                 )
        )
        if userSurvey != nil {
            sections.append(
                .init(identifier: .survey,
                      items: [.survey])
            )
        }
        sections.append(
            .init(identifier: .more,
                  items: [.roadSigns,
                          DrivingPracticeUtil.canShowInMain ? .drivingPractice : nil,
                          .highwayCode,
                          .todo,
                          .errors,
                          .favorites].compactMap({ $0 }))
        )
        
        // Log some cells
        if isViewAppeared && !isReviewCellLogged && sections.contains(
            where: { $0.identifier == .main && $0.items.contains(where: { $0 == .review }) }
        ) {
            if MainLocalBannersUtil.shared.reviewCellFirstShowDate == nil {
                MainLocalBannersUtil.shared.reviewCellFirstShowDate = Date()
            }
            RPHAnalytics.logMainScreenReviewBanner()
            isReviewCellLogged = true
        }
        if isViewAppeared && !isDrivingPracticeCellShowLogged && sections.contains(
            where: { $0.identifier == .more && $0.items.contains(where: { $0 == .drivingPractice }) }
        ) {
            RPHAnalytics.logMainScreenDrivingPracticeShown(version: DrivingPracticeUtil.version)
            isDrivingPracticeCellShowLogged = true
        }
        
        self.sections = sections
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
        NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.actionsAfterAppear()
            }
            .store(in: &cancellables)
    }
    
}
