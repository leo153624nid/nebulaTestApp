//
//  View+TrailingNavBarButton.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Add IconButton for trailing NavBar item
extension View {
    func trailingNavBarButton(image: Image?,
                              color: Color? = .accentPrimary,
                              size: CGFloat = 24,
                              action: @escaping () -> Void) -> some View {
        toolbar {
            if #available(iOS 26.0, *) {
                customToolBarItem(image: image,
                                  color: color,
                                  size: size,
                                  action: action)
                .sharedBackgroundVisibility(.hidden)
            } else {
                customToolBarItem(image: image,
                                  color: color,
                                  size: size,
                                  action: action)
            }
        }
    }
    
    private func customToolBarItem(image: Image?,
                                   color: Color? = .accentPrimary,
                                   size: CGFloat = 24,
                                   action: @escaping () -> Void) -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                action()
            } label: {
                ZStack(alignment: .trailing) {
                    // increace tap zone
                    Color.clear
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                    
                    IconButton(image: image,
                               color: color,
                               size: size,
                               action: {})
                    .allowsHitTesting(false)
                }
            }
            .buttonStyle(AlphaWhenPressedButtonStyle())
        }
    }
}
