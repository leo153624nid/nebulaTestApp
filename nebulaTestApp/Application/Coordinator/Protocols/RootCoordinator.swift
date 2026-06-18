//
//  RootCoordinator.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Root coordinator protocol.
@MainActor
protocol RootCoordinator: AnyObject, ObservableObject {
    /// Show alert.
    ///
    /// - Parameter alert: alert details.
    func showAlert(_ alert: AlertItem)
    
    /// Show tab.
    ///
    /// - Parameter tab: selected tab.
    func showTab(_ tab: AppTab)
    
    /// Show purchase.
    ///
    /// - Parameter purchase: purchase details.
    /// - Parameter forced: is forced call.
    func showPurchase(_ purchase: PurchaseCoordinatorItem, forced: Bool)
    
    /// Dismiss purchase.
    func dismissPurchase()
    
}
