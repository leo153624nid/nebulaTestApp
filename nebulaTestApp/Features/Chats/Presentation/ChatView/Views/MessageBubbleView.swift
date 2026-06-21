//
//  MessageBubbleView.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import SwiftUI

/// TODO
struct MessageBubbleView: View { // TODO
    /// Message data
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user { Spacer(minLength: 40) }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(bubbleColor)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                
                Text(message.createdAt.toTimeDisplayString())
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            if message.role == .assistant { Spacer(minLength: 40) }
        }
    }
    
    private var bubbleColor: Color {
        message.role == .user ? .accentColor : Color(white: 0.18)
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
    }
}
