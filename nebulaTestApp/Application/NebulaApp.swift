//
//  NebulaApp.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import SwiftUI

@main
struct NebulaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    private var appDelegate
    
    var body: some Scene {
        WindowGroup {
            AppRootCoordinatorView(coordinator: AppRootCoordinator())
        }
    }
}
