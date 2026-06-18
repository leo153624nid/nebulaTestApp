//
//  UINavigationBar+UpdateStyle.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import SwiftUI

extension UINavigationBar {
    /// Update UINavigationBar style.
    static func updateStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .backgroundMain
        appearance.shadowColor = .clear
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textPrimary,
            .font: UIFont.navigationBar
        ]
        appearance.titleTextAttributes = attributes
        appearance.largeTitleTextAttributes = attributes
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactScrollEdgeAppearance = appearance
    }
}
