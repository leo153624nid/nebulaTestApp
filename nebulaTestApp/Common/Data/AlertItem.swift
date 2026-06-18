//
//  AlertItem.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import SwiftUI

/// Alert data
struct AlertItem {
    /// Alert title
    let title: String
    /// Alert message
    let message: String
    /// Alert actions
    let actions: [AlertAction]
    /// Alert style
    var style: AlertStyle = .system
}

/// Action data for alert
struct AlertAction {
    /// Action button title
    let title: String
    /// Action button role
    var role: ButtonRole? = .none
    /// Action of button
    let action: () -> Void
}

/// Alert style
enum AlertStyle: Equatable {
    case system
    case designed(DesignedAlertType = .base)
}

/// Designed alert type
enum DesignedAlertType {
    /// Base
    case base
}

// MARK: - Ready alerts
extension AlertItem {
    
}
