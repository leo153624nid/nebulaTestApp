//
//  HomeCoordinatorView.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import SwiftUI

/// View with navigation for home tab.
struct HomeCoordinatorView: View {
    
    @ObservedObject var coordinator: HomeTabCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            rootView
                .navigationDestination(for: HomeTabCoordinator.Path.self) { destination in
                    Group {
                        switch destination {
                        case .chooseTicket(let context):
//                            ChooseTicketView(viewModel: context.viewModel) // TODO
                            EmptyView()
                            
                        }
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
        }
        .overlay(
            // Sometimes navigation bar content jumps when using modifier 'allowsHitTesting'.
            // Modifier 'enabled' is ok but it can cause color change for some controls.
            Color.black
                .opacity(coordinator.isNavigationDisabled ? 0.001 : 0)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity)
        )
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    @ViewBuilder private var rootView: some View {
        MainMenuView(viewModel: coordinator.rootViewModel)
    }
}
