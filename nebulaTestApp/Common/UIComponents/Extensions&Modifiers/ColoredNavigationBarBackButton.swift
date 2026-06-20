//
//  ColoredNavigationBarBackButton.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Modifier for colored special navigation bar Back button without text
struct ColoredNavigationBarBackButton: ViewModifier {
    @Environment(\.dismiss)
    private var dismiss
    
    /// Color of button icon
    private let color: Color
    /// Action on button tapped
    private let onBack: ( () -> Void )?
    
    private let isEnabled: Bool
    
    /// Initialization
    ///
    /// - Parameter color: color of button icon
    /// - Parameter onBack: action on button tapped
    init(color: Color = .accent, isEnabled: Bool, onBack: (() -> Void)? = nil) {
        self.color = color
        self.onBack = onBack
        self.isEnabled = isEnabled
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden()
            .toolbar {
                if isEnabled {
                    if #available(iOS 26.0, *) {
                        customToolBarItem()
                            .sharedBackgroundVisibility(.hidden)
                    } else {
                        customToolBarItem()
                    }
                }
            }
    }
    
    private func customToolBarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                if let onBack {
                    onBack()
                } else {
                    dismiss()
                }
            } label: {
                ZStack(alignment: .leading) {
                    // increace tap zone
                    Color.clear
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                    
                    CommonImages.Navigation.arrow.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(color)
                }
            }
            .buttonStyle(AlphaWhenPressedButtonStyle())
        }
    }
}

extension View {
    /// Apply modifier with colored special navigation bar Back button without text
    func coloredNavigationBarBackButton(_ color: Color = .accent,
                                        isEnabled: Bool = true,
                                        action: ( () -> Void )? = nil) -> some View {
        modifier(ColoredNavigationBarBackButton(color: color,
                                                isEnabled: isEnabled,
                                                onBack: action))
    }
}
