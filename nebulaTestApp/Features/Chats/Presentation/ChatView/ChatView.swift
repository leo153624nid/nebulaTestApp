//
//  ChatView.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Chat view
struct ChatView: View { // TODO: add paginating, add keyboard on start
    
    // MARK: State
    /// ViewModel
    @ObservedObject var viewModel: ChatViewModel
    /// Keyboard observer
    @StateObject private var keyboard = KeyboardObserver() // TODO
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            contentView
        }
        .trailingNavBarButton(image: CommonImages.Navigation.union.swiftUIImage,
                              color: .accent,
                              enabled: !viewModel.comeFromList) { [weak viewModel] in
            // Need a weak viewModel, because toolbar capture it
            viewModel?.perform(action: .listButtonTapped)
        }
        .toolbar {
            toolBarTitle(placement: .topBarLeading)
        }
        .coloredNavigationBarBackButton()
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.perform(action: .onAppear)
        }
        .onDisappear {
            viewModel.perform(action: .onDisappear)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .animation(.easeInOut, value: keyboard.isKeyboardVisible)
    }
    
    private func toolBarTitle(placement: ToolbarItemPlacement) -> some ToolbarContent {
        ToolbarItem(placement: placement) {
            HStack(spacing: 12) {
                /// Icon
                ZStack {
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
                        .frame(width: 32, height: 32)
                    
                    CommonImages.MainMenu.smallStars.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.accent)
                        .frame(width: 24, height: 24)
                }
                
                /// Texts
                VStack(alignment: .leading) {
                    Text(Str.ChatView.screenTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.textAccent)
                        .lineLimit(1)
                    
                    Text(viewModel.chat.updatedAt.toDisplayString())
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.textAccent.opacity(0.3))
                        .lineLimit(1)
                }
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.isLoading {
                
                loadingView
                    .transition(.opacity)
                
            } else if let error = viewModel.errorMessage {
                
                messageView(title: Str.ChatView.Error.title,
                            description: error)
                    .transition(.opacity)
                
            } else if viewModel.messages.isEmpty {
                
                messageView(title: Str.ChatView.EmptyList.title, // TODO: add gradient
                            description: Str.ChatView.EmptyList.desc)
                    .transition(.opacity)
                
            } else {
                
                messagesScrollView
                    .transition(.opacity)
                
            }
            
            ChatInputView(text: $viewModel.inputText,
                          isSending: viewModel.isSending,
                          onSend: { viewModel.perform(action: .sendMessage) })
        }
//        .offset(y: keyboard.isKeyboardVisible ? -headerOffset : 0) // TODO
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .animation(.easeInOut, value: viewModel.messages)
        .animation(.easeInOut, value: viewModel.errorMessage)
        .animation(.easeInOut, value: viewModel.isSending)
    }
    
    private var loadingView: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                .frame(width: 20, height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var messagesScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) {
                        MessageBubbleView(message: $0)
                            .id($0.id)
                    }
                    
                    if viewModel.isSending {
                        TypingIndicatorView()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
            }
            .onChange(of: viewModel.messages.count) { _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.isSending) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let lastID = viewModel.messages.last?.id else { return }
        
        withAnimation(.easeOut(duration: 0.25)) {
            proxy.scrollTo(lastID, anchor: .bottom)
        }
    }
    
    private func messageView(title: String,
                             description: String) -> some View { // TODO: add gradient
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(Color.textAccent)
            
            Text(description)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.textAccent.opacity(0.5))
                .lineLimit(nil)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}

#Preview {
    NavigationStack {
        ChatView(
            viewModel: ChatViewModel(
                coordinator: HomeTabCoordinator(parent: AppRootCoordinator())
            )
        )
    }
}
