//
//  Coordinator.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Base coordinator protocol.
@MainActor
protocol Coordinator: RootCoordinator {
    associatedtype Coordinator: RootCoordinator
    associatedtype ViewModel
    
    /// Parent coordinator.
    var parent: Coordinator { get }
    /// View model of root view.
    var rootViewModel: ViewModel! { get }
    
    /// Initialization.
    ///
    /// - Parameter parent: parent coordinator.
    init(parent: Coordinator)
    
    /// Show alert.
    ///
    /// - Parameter alert: alert details.
    func showAlert(_ alert: AlertItem)
    
    /// Show purchase.
    ///
    /// - Parameter purchase: purchase details.
    /// - Parameter forced: is forced call.
    func showPurchase(_ purchase: PurchaseCoordinatorItem, forced: Bool)
    
    /// Dismiss purchase.
    func dismissPurchase()
    
    /// Open previous screen.
    func pop()
    
    /// Open root screen.
    func popToRoot()
    
}

extension Coordinator {
    func showTab(_ tab: AppTab) {
        parent.showTab(tab)
    }
    
    func showAlert(_ alert: AlertItem) {
        parent.showAlert(alert)
    }
    
    func showPurchase(_ purchase: PurchaseCoordinatorItem, forced: Bool = false) {
        parent.showPurchase(purchase, forced: forced)
    }
    
    func dismissPurchase() {
        parent.dismissPurchase()
    }
    
}
