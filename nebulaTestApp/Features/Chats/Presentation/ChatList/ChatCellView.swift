//
//  ChatCellView.swift
//  nebulaTestApp
//
//  Created by A Ch on 20.06.2026.
//

import SwiftUI

/// Cell view for chat list
struct ChatCellView: View {
    
    private let chat: Chat
    private let headerText: String
    private let dateText: String
    
    /// Initialization
    /// - Parameter chat: chat data
    init(chat: Chat) {
        self.chat = chat
        self.headerText = chat.title ?? chat.lastMessagePreview ?? chat.id
        self.dateText = chat.updatedAt.toTimeDisplayString()
    }
    
    var body: some View {
        HStack(spacing: 24) {
            CommonImages.MainMenu.smallStars.swiftUIImage
                .resizable()
                .scaledToFit()
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            .accentGradientStart,
                            .accentGradientEnd
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 28, height: 28)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(headerText)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.textAccent)
                    .lineLimit(1)
                    .truncationMode(.tail)
                
                Text(dateText)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.textAccent.opacity(0.4))
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.card.opacity(0.4))
        .clipShape(RoundedCorners(radius: 24))
    }
    
}

#Preview {
    ChatCellView(chat: Chat(id: "id",
                            title: "Title sgdfdfb svsb sb db dfb dfb d bd fbdfbd dbbbd dbdbf dbf dfb",
                            updatedAt: .now,
                            lastMessagePreview: "last message"))
}
