//
//  View+HideKeyboard.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

extension View {
    /// Hide keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
