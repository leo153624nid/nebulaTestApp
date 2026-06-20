//
//  UITabBar+UpdateStyle.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

import SwiftUI
import UIKit.UITabBar

extension UITabBar {
    /// Update UITabBar style.
    static func updateStyle() {
        let tabBar = UITabBar.appearance()
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundImage = UIImage(resource: .tabBarBackground)
            .withTintColor(UIColor(resource: .accent))
            .resizableAtCenter()
        tabBarAppearance.shadowImage = nil
        
        let stackedLayoutAppearance = tabBarAppearance.stackedLayoutAppearance
        stackedLayoutAppearance.selected.iconColor = UIColor(resource: .accentGradientEnd)
        stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(resource: .accentGradientEnd)]
        stackedLayoutAppearance.normal.iconColor = UIColor(resource: .card)
        stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(resource: .textSecondary)]
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
