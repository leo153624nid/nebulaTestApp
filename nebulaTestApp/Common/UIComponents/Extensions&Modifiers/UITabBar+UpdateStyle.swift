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
            .withTintColor(UIColor(resource: .backgroundMain))
            .resizableAtCenter()
        tabBarAppearance.shadowImage = nil
        
        let stackedLayoutAppearance = tabBarAppearance.stackedLayoutAppearance
        stackedLayoutAppearance.selected.iconColor = UIColor(resource: .brandPrimary)
        stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(resource: .brandPrimary)]
        stackedLayoutAppearance.normal.iconColor = UIColor(resource: .neutralSecondary)
        stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(resource: .neutralSecondary)]
        
        tabBar.standardAppearance = tabBarAppearance
        tabBar.scrollEdgeAppearance = tabBarAppearance
    }
}
