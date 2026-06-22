//
//  PaywallError.swift
//  nebulaTestApp
//
//  Created by A Ch on 22.06.2026.
//

import ApphudSDK
import Foundation

/// Wrapper on AdaptyError & AdaptyUIError
struct PaywallError: Error {
    /// Adapty error
    let apphudError: ApphudError?
    /// Original error
    let originalError: Error
    
    /// Initialization
    ///
    /// - Parameter error: original error
    init(_ error: Error) {
        self.apphudError = error as? ApphudError
        self.originalError = error
    }
}

extension PaywallError {
    /// Error localized description
    var message: String {
        let message = if let purchaseMessage = apphudError?.debugDescription {
            purchaseMessage
        } else {
            (originalError as? String) ?? originalError.localizedDescription
        }
        return message
    }
    
}
