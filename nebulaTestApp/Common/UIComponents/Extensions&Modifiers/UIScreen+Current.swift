//
//  UIScreen+Current.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

extension UIWindowScene {
    static var current: UIWindowScene? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return scene
    }
}

extension UIWindow {
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }

            return windowScene.windows.first(where: { $0.isKeyWindow })
        }
        return nil
    }
}

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
