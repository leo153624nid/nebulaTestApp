//
//  HomeTabCoordinator.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation
import SwiftUI
import Combine

/// Home tab coordinator
final class HomeTabCoordinator: Coordinator {
    // MARK: - Properties
    
    /// Parent coodinator.
    unowned let parent: AppRootCoordinator
    /// Own ViewModel.
    @Published var rootViewModel: MainMenuViewModel!
    /// User flow.
    @Published var path = [Path]()
    /// Navigation is disabled.
    @Published var isNavigationDisabled = false
    
    // MARK: - Initialization
    
    /// Initialization.
    ///
    /// - Parameter parent: parent coordinator.
    init(parent: AppRootCoordinator) {
        self.parent = parent
        self.rootViewModel = MainMenuViewModel(coordinator: self)
    }
    
    // MARK: - Navigation

    /// Replace top screen.
    ///
    /// - Parameter oldPath: current screen.
    /// - Parameter newPath: new screen.
    private func replaceTopPath(_ oldPath: Path, with newPath: Path) {
        let isReplace = oldPath == path.last
        
        path.append(newPath)
        
        if isReplace {
            isNavigationDisabled = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) {
                let count = self.path.count
                guard count > 1 else {
                    self.isNavigationDisabled = false
                    return
                }
                
                UIView.setAnimationsEnabled(false)
                
                let index = count - 2
                if oldPath == self.path[index] {
                    self.path.remove(at: index)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(250)) {
                    UIView.setAnimationsEnabled(true)
                    self.isNavigationDisabled = false
                }
            }
        }
    }

    /// Open previous screen.
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Open root screen.
    func popToRoot() {
        path.removeAll()
    }
    
}

extension HomeTabCoordinator {
    /// Screens for navigation.
    @MainActor
    enum Path: Hashable {
        case chooseTicket(context: FlowModelContext<MainMenuViewModel>) // TODO
    }
}
