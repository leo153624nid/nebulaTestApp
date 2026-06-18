//
//  AppRootCoordinator.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Combine
import Foundation
import SafariServices

/// Application root coordinator
@MainActor
final class AppRootCoordinator: RootCoordinator {
    // MARK: - Properties
    
    /// Subscriptions store
    private var cancellables = Set<AnyCancellable>()
    
    /// Selected root tab.
    @Published var tab = AppTab.home {
        didSet {
            handleTabClick(oldValue: oldValue)
        }
    }
    
    /// Main menu module coordinator.
    @Published var mainMenuCoordinator: HomeTabCoordinator!
    /// Alert data item.
    @Published var alert: AlertItem?
    /// Purchase data item.
    @Published var purchase: PurchaseCoordinatorItem?
    
    // MARK: - Initialization
    
    /// Initialization.
    init() {
        mainMenuCoordinator = HomeTabCoordinator(parent: self)
        setupSubscriptions()
    }
    
    // MARK: - Private
    
    private func setupSubscriptions() {
        
    }
    
    private func handleTabClick(oldValue: AppTab) {
        
    }
    
    // MARK: - Other
    
    /// Show alert
    ///
    /// - Parameter alert: alert details.
    func showAlert(_ alert: AlertItem) {
        self.alert = alert
    }
    
    /// Show tab.
    ///
    /// - Parameter tab: selected tab.
    func showTab(_ tab: AppTab) {
        self.tab = tab
    }
    
    /// Show purchase.
    ///
    /// - Parameter purchase: purchase details.
    /// - Parameter forced: is forced call.
    func showPurchase(_ purchase: PurchaseCoordinatorItem, forced: Bool = false) { // TODO
//        guard !forced else {
//            self.purchase = purchase
//            return
//        }
//        
//        if purchase.accessType == .extraHazard && ActivationInfo.hasExtraHazardAccess {
//            purchase.viewModel.completion?(false)
//        } else if purchase.accessType == .fullVersion && ActivationInfo.isFullVersion {
//            purchase.viewModel.completion?(false)
//        } else {
//            self.purchase = purchase
//        }
    }
    
    /// Dismiss purchase.
    func dismissPurchase() {
        purchase = nil
    }
    
}
