//
//  ChatListView.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Chat view
struct ChatListView: View {
    
    /// ViewModel
    @ObservedObject var viewModel: ChatListViewModel
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            contentView
                .refreshable {
                    viewModel.perform(action: .pullToRefresh)
                }
        }
        .toolbar {
            toolBarTitle(placement: .principal)
        }
        .coloredNavigationBarBackButton()
        .preferredColorScheme(.dark)
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
                .foregroundStyle(.textAccent)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading) {
            if viewModel.isLoading {
                
                loadingView
                    .transition(.opacity)
                
            } else if let message = viewModel.errorMessage {
                
                messageView(title: Str.ChatListView.Error.title,
                            description: message)
                    .transition(.opacity)
                
            } else if viewModel.sections.isEmpty {
                
                messageView(title: Str.ChatListView.EmptyList.title,
                            description: Str.ChatListView.EmptyList.desc)
                    .transition(.opacity)
                
            } else {
                
                listView
                    .transition(.opacity)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .animation(.easeInOut, value: viewModel.isLoading)
        .animation(.easeInOut, value: viewModel.errorMessage)
        .animation(.easeInOut, value: viewModel.sections)
    }
    
    private func messageView(title: String,
                             description: String) -> some View {
        VStack(spacing: 8) {
            CommonImages.MainMenu.magicPencil.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.textAccent)
            
            Text(description)
                .font(.system(size: 16, weight: .regular))
                .foregroundStyle(Color.textAccent.opacity(0.3))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadingView: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .accent))
                .frame(width: 20, height: 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                ForEach(viewModel.sections) { section in
                    Section {
                        ForEach(section.chats, id: \.id) {
                            chatCellView($0)
                                .transition(.opacity)
                        }
                    } header: {
                        sectionHeaderView(section.id)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private func chatCellView(_ chat: Chat) -> some View {
        Button {
            viewModel.perform(action: .selectChat(chat))
        } label: {
            ChatCellView(chat: chat)
        }
        .buttonStyle(AlphaWhenPressedButtonStyle())
    }
    
    private func sectionHeaderView(_ date: Date) -> some View {
        Text(date.toSectionHeaderString())
            .font(.system(size: 20, weight: .semibold))
            .foregroundStyle(Color.textAccent)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 20)
            .padding(.bottom, 10)
            .background(Color.background)
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
