//
//  TypingIndicatorView.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import SwiftUI

/// Typing Indicator View
struct TypingIndicatorView: View {
    
    @State private var animating = false
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .accentGradientStart,
                                .accentGradientEnd
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 19, height: 19)
                    .scaleEffect(animating ? 1 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.5)
                        .repeatForever()
                        .delay(Double(i) * 0.15),
                        value: animating
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .background(Color.card.opacity(0.5))
        .clipShape(RoundedCorners(corners: [.topLeft, .topRight, .bottomRight],
                                  radius: 24))
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    TypingIndicatorView()
}
