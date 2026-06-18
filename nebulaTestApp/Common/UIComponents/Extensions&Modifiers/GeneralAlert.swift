//
//  GeneralAlert.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import SwiftUI

/// View modifier for presenting alert view
struct GeneralAlert: ViewModifier {
    /// Alert data
    @Binding var alertItem: AlertItem?
    
    /// State for managing custom alert animations
    @State private var isVisible = false
    /// Height of content designed alert
    @State private var contentHeight: CGFloat = .zero
    /// Height of content designed alert in alert view
    @State private var contentHeightInAlert: CGFloat = .zero
    /// Duration of custom alert animations
    private let duration: TimeInterval = 0.3

    func body(content: Content) -> some View {
        ZStack {
            // System alert
            content
                .alert(
                    alertItem?.title ?? "",
                    isPresented: Binding(
                        get: {
                            alertItem != nil && alertItem?.style == .system
                        }, set: {
                            if !$0 && alertItem?.style == .system {
                                alertItem = nil
                            }
                        }
                    ),
                    presenting: alertItem,
                    actions: { item in
                        ForEach(item.actions, id: \.title) { action in
                            Button(role: action.role) {
                                action.action()
                            } label: {
                                Text(action.title)
                            }
                        }
                    },
                    message: { item in
                        Text(item.message)
                    }
                )
            
            // Designed alert
            if let alertItem, case .designed = alertItem.style {
                let alignment: Alignment = if case .designed(.base) = alertItem.style {
                    .center
                } else {
                    .bottom
                }
                
                ZStack(alignment: alignment) {
                    // TODO: update if needed
                }
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: duration)) {
                        isVisible = true
                    }
                }
            }
        }
        .animation(.easeInOut, value: isVisible)
    }
    
    /// Dismiss with animation, for designed alert
    private func dismissWithAnimation() {
        withAnimation(.easeInOut(duration: duration)) {
            isVisible = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + 0.3) {
            alertItem = nil
        }
    }
    
}

extension View {
    /// Aplly general alert modifier to view
    func generalAlert(item: Binding<AlertItem?>) -> some View {
        modifier(GeneralAlert(alertItem: item))
    }
}

#Preview("System") {
    Color.white.ignoresSafeArea()
        .generalAlert(
            item: .constant(
                AlertItem(title: "title",
                          message: "message",
                          actions: [
                            AlertAction(title: "Cancel",
                                        action: { }),
                            AlertAction(title: "Reset",
                                        role: .cancel,
                                        action: { })
                          ],
                          style: .system)
            )
        )
}
