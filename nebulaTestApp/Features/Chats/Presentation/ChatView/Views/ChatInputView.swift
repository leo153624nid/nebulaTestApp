//
//  ChatInputView.swift
//  nebulaTestApp
//
//  Created by A Ch on 21.06.2026.
//

import SwiftUI

/// Input view for chat
struct ChatInputView: View {
    /// Input text
    @Binding var text: String
    /// Text is sending
    let isSending: Bool
    /// Action for send button
    let onSend: () -> Void
    
    @FocusState private var isFocused: Bool
    @State private var textEditorHeight: CGFloat = minHeight
    @State private var rawTextHeight: CGFloat = minHeight
    
    private static let minHeight: CGFloat = 88
    private let maxHeight: CGFloat = 120
    
    var body: some View {
        HStack(spacing: 20) {
            textInputField
            
            sendButton
        }
        .background(Color.card)
        .clipShape(RoundedCorners(corners: [.topLeft, .topRight],
                                  radius: 24))
    }
    
    private var textInputField: some View {
        ZStack(alignment: .leading) {
            // Placeholder
            if text.isEmpty {
                Text(Str.ChatView.inputPlaceholder)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.textAccent.opacity(0.4))
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Невидимый Text для измерения высоты содержимого
            Text(text.isEmpty ? " " : text)
                .font(.system(size: 16, weight: .regular))
                .padding(.horizontal, 8)
                .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .background(GeometryReader { geometry in
                    Color.clear
                        .preference(key: TextHeightPreferenceKey.self,
                                    value: geometry.size.height)
                })
                .opacity(0)
                .allowsHitTesting(false)
            
            TextEditor(text: $text)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(.textAccent)
                .focused($isFocused)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 8)
                .padding(.vertical, extraTopPadding)
                .frame(height: textEditorHeight)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isFocused = true
                    }
                }
        }
        .frame(minHeight: Self.minHeight)
        .onPreferenceChange(TextHeightPreferenceKey.self) { height in
            rawTextHeight = height
            textEditorHeight = min(max(height, Self.minHeight), maxHeight)
        }
    }
    
    private var sendButton: some View {
        Button(action: onSend) {
            if isSending {
                
                ProgressView()
                    .tint(.accent)
                    .frame(width: 40, height: 40)
                
            } else if text.isEmpty {
                
                CommonImages.Chat.download.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.accent)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .stroke(Color.accent.opacity(0.3), lineWidth: 1)
                    )
                
            } else {
                
                CommonImages.Chat.send.swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                
            }
        }
        .disabled(!canSend)
        .padding(.trailing, 16)
        .animation(.easeInOut, value: text)
    }
    
    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isSending
    }
    
    /// Compensates so that short (1-line) text appears vertically centered
    /// inside the minHeight container, instead of sticking to the top.
    private var extraTopPadding: CGFloat {
        max(0, (Self.minHeight - rawTextHeight) / 2)
    }
}

private struct TextHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
//        value = nextValue()
    }
}

#Preview {
    VStack(spacing: 10) {
        ChatInputView(text: .constant(""),
                      isSending: false,
                      onSend: {})
        
        ChatInputView(text: .constant("Hi! Can you help me write"),
                      isSending: true,
                      onSend: {})
        
        ChatInputView(text: .constant("Hi! Can you help me write a short welcome email for a new employee joining our team?"),
                      isSending: false,
                      onSend: {})
        
        ChatInputView(text: .constant("Hi! Can you help me write a short welcome email for a new employee"),
                      isSending: false,
                      onSend: {})
    }
}
