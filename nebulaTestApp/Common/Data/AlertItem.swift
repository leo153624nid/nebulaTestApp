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
    /// Alert item for new chat id error
    static func newChatIdAlertItem() -> AlertItem {
        AlertItem(title: "Error", // TODO: localize
                  message: "No chat id", // TODO: localize
                  actions: [
                    AlertAction(title: Str.Common.ok, action: {})
                  ])
    }
    
#if DEBUG
    /// Alert item for setup prod credentials
    static func setupCredentialsAlertItem(completion: @escaping () -> Void) -> AlertItem {
        AlertItem(title: "No credentials",
                  message: "Setup your credentials in Common/Data/AppConstants.example.swift",
                  actions: [
                    AlertAction(title: Str.Common.ok, action: { completion() })
                  ])
    }
#endif
    
}
