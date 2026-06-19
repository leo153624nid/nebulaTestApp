//
//  AlphaWhenPressedButtonStyle.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Button style with some alpha when pressed
struct AlphaWhenPressedButtonStyle: ButtonStyle {
    
    private let alphaValue: Double
    
    /// Initialization
    ///
    /// - Parameter alphaValue: opacity value, 0...1
    init(_ alphaValue: Double = 0.75) {
        switch alphaValue {
        case 0...1:
            self.alphaValue = alphaValue
        default:
            self.alphaValue = 1
        }
    }
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? alphaValue : 1)
    }
}
