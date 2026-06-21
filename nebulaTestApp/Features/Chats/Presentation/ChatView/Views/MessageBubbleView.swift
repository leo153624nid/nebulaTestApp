//
//  MessageBubbleView.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import SwiftUI

/// Chat message bubble view
struct MessageBubbleView: View {
    /// Message data
    let message: ChatMessage
    
    private let style: AnyShapeStyle
    private let corners: UIRectCorner
    
    init(message: ChatMessage) {
        self.message = message
        self.style = Self.fillStyle(isGradient: message.role == .user)
        self.corners = Self.corners(isUser: message.role == .user)
    }
    
    var body: some View {
        HStack {
            if message.role == .user { Spacer(minLength: 0) }
            
                Text(message.content)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.textAccent)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 16)
                    .background {
                        Rectangle()
                            .fill(style)
                            .clipShape(RoundedCorners(corners: corners,
                                                      radius: 24))
                    }
            
            if message.role == .assistant { Spacer(minLength: 0) }
        }
    }
    
    private static func fillStyle(isGradient: Bool) -> AnyShapeStyle {
        if isGradient {
            return AnyShapeStyle(
                LinearGradient(
                    colors: [
                        .accentGradientStart,
                        .accentGradientEnd
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
        return AnyShapeStyle(Color.card.opacity(0.5))
    }
    
    private static func corners(isUser: Bool) -> UIRectCorner {
        if isUser {
            return [.topLeft, .topRight, .bottomLeft]
        }
        return [.topLeft, .topRight, .bottomRight]
    }
}

#Preview {
    VStack(spacing: 10) {
        MessageBubbleView(message: ChatMessage(content: "Assistant message",
                                               role: .assistant,
                                               createdAt: .now))
        
        MessageBubbleView(message: ChatMessage(content: "User message sdvsdvsvsv sb fbdb edb e be  b e be b eb eb e b ebr e br ebr b e rb ",
                                               role: .user,
                                               createdAt: .now))
        
        MessageBubbleView(message: ChatMessage(content: "Assistant message sdvsv sv vw vr ve rve vre rre  cer ve rv erv e vr erv er ve rv erv er vre v erv er v erv erv e rv erv e rv erv ev e v ev e rv erv e rv erv er ve rv erv  vr vr evrv e rv erv ver  evr erv ",
                                               role: .assistant,
                                               createdAt: .now))
        
        MessageBubbleView(message: ChatMessage(content: "User message",
                                               role: .user,
                                               createdAt: .now))
        
        Spacer()
    }
    .padding(.all, 16)
}
