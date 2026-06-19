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
        contentView
            .ignoresSafeArea(edges: .bottom)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(Str.ChatListView.screenTitle)
            .coloredNavigationBarBackButton()
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: sectionVerticalSpacing) {
            headerView
                .padding(.horizontal, 16)
            
//            searchView
//                .padding(.horizontal, 16)
            
//            stateListView
        }
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.backgroundMain)
//        .animation(.easeInOut, value: viewModel.results)
//        .allowsHitTesting(!viewModel.isViewDisabled)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Str.ChatListView.screenTitle) // TODO
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.textPrimary)
            
            Text(Str.ChatListView.screenTitle) // TODO
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
        }
    }
    
//    private var searchView: some View {
//        HStack(spacing: 8) {
//            CommonImages.Pdd.search.swiftUIImage
//                .resizable()
//                .scaledToFit()
//                .frame(width: 20, height: 20)
//                .foregroundStyle(Color.textSecondary)
//            
//            ColoredPlaceholderTextField(text: $viewModel.searchText,
//                                        placeholder: Str.AppSpecificLocalizable.SelectState.searchPlaceholder)
//            .submitLabel(.done)
//            .textContentType(.addressState)
//        }
//        .padding(.horizontal, 16)
//        .frame(height: nextButtonHeight)
//        .background(Color.backgroundAlternative)
//        .clipShape(RoundedRectangle(cornerRadius: 24))
//    }
    
//    private var stateListView: some View {
//        ScrollView {
//            LazyVStack(spacing: stateItemSpacing) {
//                ForEach(viewModel.results, id: \.rawValue) { state in
//                    StateCellView(state: state,
//                                  isSelected: viewModel.selectedState == state,
//                                  onTap: { viewModel.perform(action: .selectState(state)) })
//                    .equatable()
//                    .transition(.opacity)
//                }
//            }
//            .padding(.bottom, nextButtonHeight + 2 * stateItemSpacing + bottomSafeAreaPadding
//                     + specialBottomPadding) // fixing visible tabbar inset bug
//            .padding(.horizontal, 16)
//        }
//        .simultaneousGesture(
//            DragGesture().onChanged { _ in
//                hideKeyboard()
//            }
//        )
//    }
    
//    private var overlayView: some View {
//        VStack {
//            Spacer()
//            
//            nextButton
//                .padding(.bottom, specialBottomPadding) // fixing visible tabbar inset bug
//        }
//        .padding(.horizontal, 16)
//        .padding(.bottom, bottomSafeAreaPadding)
//        .opacity(keyboard.isKeyboardVisible ? 0 : 1)
//    }
    
//    private var nextButton: some View {
//        Button {
//            hideKeyboard()
//            viewModel.perform(action: .nextButtonTapped)
//        } label: {
//            TextBadgeView(title: Str.AppSpecificLocalizable.SelectState.nextButtonTitle,
//                          height: nextButtonHeight,
//                          isInfinityWidth: true,
//                          fontSize: 16,
//                          fontWeight: .bold,
//                          titleColor: .textContrast,
//                          backgroundColor: .accentPrimary)
//        }
//        .buttonStyle(AlphaWhenPressedButtonStyle())
//        .disabled(viewModel.selectedState == nil)
//        .background(Color.backgroundMain.clipShape(.rect(cornerRadius: 16)))
//        .padding(.bottom, 1)
//    }
    
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
