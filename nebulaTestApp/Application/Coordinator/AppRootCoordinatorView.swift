//
//  AppRootCoordinatorView.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import SwiftUI

/// Application tabbar view with navigation setup
struct AppRootCoordinatorView: View {
    /// Coordinator.
    @ObservedObject var coordinator: AppRootCoordinator
    
    var body: some View {
        TabView(selection: $coordinator.tab) {
            HomeCoordinatorView(coordinator: coordinator.mainMenuCoordinator)
                .tabItem {
                    Label(Str.Common.languageCode, // TODO
                          image: CommonImages.TabBar.home.name)
                }
                .tag(AppTab.home)
        }
        .generalAlert(item: $coordinator.alert)
//        .fullScreenCover(item: $coordinator.purchase) { item in // TODO
//            PurchaseView(viewModel: item.viewModel)
//        }
    }
}
