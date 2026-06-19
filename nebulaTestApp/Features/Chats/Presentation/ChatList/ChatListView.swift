//
//  ChatListView.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Chat view
struct ChatListView: View {
    
    // MARK: State
    /// ViewModel
    @ObservedObject var viewModel: ChatListViewModel
    
    // MARK: Dimensions
    /// Next button height
    private let nextButtonHeight: CGFloat = 44
    /// Spacing between adjacent state cells
    private let stateItemSpacing: CGFloat = 8
    /// Spacing between sections
    private let sectionVerticalSpacing: CGFloat = 16
    /// Padding for fixing visible tabbar inset bug
    private let specialBottomPadding: CGFloat = {
        return if #available(iOS 26.0, *) {
            50
        } else {
            0
        }
    }()
    
    var body: some View {
        ZStack {
            Color.red // TODO
                .ignoresSafeArea()
            
            contentView
//                .ignoresSafeArea(edges: .bottom) // TODO
        }
        .toolbar {
            toolBarTitle(placement: .principal)
        }
        .coloredNavigationBarBackButton()
        .onAppear {
            viewModel.perform(action: .onAppear)
        }
        .onDisappear {
            viewModel.perform(action: .onDisappear)
        }
    }
    
    private func toolBarTitle(placement: ToolbarItemPlacement) -> some ToolbarContent {
        ToolbarItem(placement: placement) {
            Text(Str.ChatListView.screenTitle)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.textPrimary) // TODO
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                loadingView
            } else if let message = viewModel.errorMessage {
                messageView(title: Str.ChatListView.Error.title,
                            description: message)
            } else if viewModel.chatList.isEmpty {
                messageView(title: Str.ChatListView.EmptyList.title,
                            description: Str.ChatListView.EmptyList.desc)
            } else {
                listView
            }
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.red) // TODO
        .animation(.easeInOut, value: viewModel.isLoading)
        .animation(.easeInOut, value: viewModel.errorMessage)
        .animation(.easeInOut, value: viewModel.chatList)
    }
    
    private func messageView(title: String,
                             description: String) -> some View {
        VStack(spacing: 8) {
            Rectangle() // TODO: add pic
                .fill(Color.yellow) // TODO
                .frame(width: 60, height: 60)
            
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.accentGradientEnd) // TODO
            
            Text(description)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.textSecondary) // TODO
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadingView: some View {
        ZStack {
            ProgressView() // TODO: update color
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 20, height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: stateItemSpacing) {
                ForEach(viewModel.chatList, id: \.id) { chat in
                    Text(chat.updatedAt.toDisplayString()) // TODO: update cell
                    .equatable()
                    .transition(.opacity)
                    .onTapGesture {
                        viewModel.perform(action: .selectChat(chat))
                    }
                }
            }
            .padding(.bottom, nextButtonHeight + 2 * stateItemSpacing + specialBottomPadding) // fixing visible tabbar inset bug // TODO
            .padding(.horizontal, 16)
        }
    }
    
}

#Preview {
    NavigationStack {
        ChatListView(
            viewModel: ChatListViewModel(
                coordinator: HomeTabCoordinator(parent: AppRootCoordinator())
            )
        )
    }
}
