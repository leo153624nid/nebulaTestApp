//
//  ChatView.swift
//  nebulaTestApp
//
//  Created by A Ch on 19.06.2026.
//

import SwiftUI

/// Chat view
struct ChatView: View {
    
    // MARK: State
    /// ViewModel
    @ObservedObject var viewModel: ChatViewModel
    /// Keyboard observer
    @StateObject private var keyboard = KeyboardObserver()
    /// Height of header for offset
    @State private var headerOffset: CGFloat = 0
    
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
            .trailingNavBarButton(image: CommonImages.Navigation.angleRight.swiftUIImage,
                                  color: .neutralSecondary) { [weak viewModel] in
                // Need a weak viewModel, because toolbar capture it
                viewModel?.perform(action: .listButtonTapped)
            }
            .toolbar {
                toolBarTitle(placement: .topBarLeading)
            }
            .coloredNavigationBarBackButton()
            .animation(.easeInOut, value: keyboard.isKeyboardVisible)
    }
    
    private func toolBarTitle(placement: ToolbarItemPlacement) -> some ToolbarContent {
        ToolbarItem(placement: placement) {
            HStack(spacing: 12) {
                Circle() // TODO: take pic
                    .foregroundStyle(Color.accentPrimary) // TODO: delete
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading) {
                    Text(Str.ChatView.screenTitle)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.textPrimary) // TODO
                        .lineLimit(1)
                    
                    Text(viewModel.chat.updatedAt.toDisplayString())
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.textSecondary) // TODO
                        .lineLimit(1)
                }
            }
            .fixedSize(horizontal: true, vertical: false)
        }
    }
    
    private var contentView: some View {
        VStack(alignment: .leading, spacing: sectionVerticalSpacing) {
            headerView
                .padding(.horizontal, 16)
                .opacity(keyboard.isKeyboardVisible ? 0 : 1)
            
//            searchView
//                .padding(.horizontal, 16)
            
//            stateListView
        }
        .offset(y: keyboard.isKeyboardVisible ? -headerOffset : 0)
        .padding(.top, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.backgroundMain)
//        .animation(.easeInOut, value: viewModel.results)
        .onTapGesture {
            hideKeyboard()
        }
//        .allowsHitTesting(!viewModel.isViewDisabled)
    }
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(Str.ChatView.screenTitle) // TODO
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.textPrimary)
            
            Text(Str.ChatView.screenTitle) // TODO
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        headerOffset = geo.size.height + sectionVerticalSpacing
                    }
                    .onChange(of: geo.size.height) { newValue in
                        headerOffset = newValue + sectionVerticalSpacing
                    }
            }
        )
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
        ChatView(
            viewModel: ChatViewModel(
                coordinator: HomeTabCoordinator(parent: AppRootCoordinator())
            )
        )
    }
}





import Combine
import SwiftUI

/// Keyboard observer
final class KeyboardObserver: ObservableObject {
    /// Keyboard is visible
    @Published private(set) var isKeyboardVisible = false
    /// Current keyboard height
    @Published private(set) var keyboardHeight: CGFloat = 0
    
    /// Keyboard height publisher
    var heightPublisher: AnyPublisher<CGFloat, Never> {
        $keyboardHeight
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private var bag = Set<AnyCancellable>()

    init() {
        let nc = NotificationCenter.default
        nc.publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .merge(with: nc.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] note in self?.handle(note) }
            .store(in: &bag)
    }
    
    private func handle(_ note: Notification) {
        guard let window = UIWindow.current,
              let info = note.userInfo,
              let endValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let kbEndOnScreen = endValue.cgRectValue
        let kbEndInWindow = window.convert(kbEndOnScreen, from: nil)
        
        // сколько клавиатура перекрывает низ окна
        let rawOverlap = max(0, window.bounds.maxY - kbEndInWindow.origin.y)
        
        // вычитаем нижний safe area у окна, чтобы не «удвоить» отступ
        let effectiveOverlap = max(0, rawOverlap - window.safeAreaInsets.bottom)
        
        DispatchQueue.main.async {
            self.isKeyboardVisible = effectiveOverlap > 0
            self.keyboardHeight = effectiveOverlap
        }
    }
    
}
