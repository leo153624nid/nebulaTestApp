//
//  PurchaseCoordinatorItem.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Description of purchase for coordinator.
@MainActor
struct PurchaseCoordinatorItem: Identifiable {
    /// Callback after showing view, false on failed to show paywall
    typealias CloseCallback = (Bool) -> Void
    
    /// Identifier.
    let id = UUID()
    /// Purchase view model
//    let viewModel: PurchaseViewModel // TODO
    
    /// Initialization with paywall style.
    ///
    /// - Parameter coordinator: coordinator.
    /// - Parameter source: context for analytics. Usually it is prevoius screen name.
    /// - Parameter style: paywall style.
    /// - Parameter accessType: access type.
    /// - Parameter completion: callback after showing view, false on failed to show paywall
    init(coordinator: any Coordinator,
         style: PaywallStyle,
         completion: CloseCallback? = nil) {
//        self.viewModel = PurchaseViewModel(coordinator: coordinator,
//                                           source: source,
//                                           style: style,
//                                           completion: completion)
    }
}
