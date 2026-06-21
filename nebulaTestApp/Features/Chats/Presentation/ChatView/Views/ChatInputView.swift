//
//  ChatInputView.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import SwiftUI

/// Input view for chat
struct ChatInputView: View { // TODO
    /// Input text
    @Binding var text: String
    /// Text is sending
    let isSending: Bool
    /// Action for send button
    let onSend: () -> Void
    
    @FocusState private var isFocused: Bool
    private let maxHeight: CGFloat = 120
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            textInputField
            
            sendButton
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(white: 0.1))
    }
    
    private var textInputField: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text("Сообщение")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
            }
            
            TextEditor(text: $text)
                .focused($isFocused)
                .scrollContentBackground(.hidden)
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .frame(minHeight: 36, maxHeight: maxHeight)
        }
        .background(Color(white: 0.18))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var sendButton: some View {
        Button(action: onSend) {
            if isSending {
                ProgressView()
                    .tint(.white)
                    .frame(width: 32, height: 32)
            } else {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(canSend ? Color.accentColor : Color.gray)
            }
        }
        .disabled(!canSend)
    }
    
    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSending
    }
}

#Preview {
    ChatInputView(text: .constant("promt"),
                  isSending: false,
                  onSend: {})
}
