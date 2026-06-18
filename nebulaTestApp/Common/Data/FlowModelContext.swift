//
//  FlowModelContext.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import Foundation

/// Hashable context of screen for coordinator.
class FlowModelContext<VM: ViewModel>: Identifiable, Hashable {
    /// View model.
    private(set) var viewModel: VM
    
    /// Initialization.
    ///
    /// - Parameter model: view model.
    init(model: VM) {
        self.viewModel = model
    }
    
    /// Unique identifier
    let id = UUID()
    
    /// Equality Comparison Operator
    ///
    /// - Parameter lhs: first instance.
    /// - Parameter rhs: second instance.
    ///
    /// - Returns: `true` if the instances are equal, `false` otherwise.
    static func == (lhs: FlowModelContext, rhs: FlowModelContext) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Hashes the current object using the passed hasher.
    ///
    /// - Parameter hasher: The `Hasher` object used to calculate the hash value.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
