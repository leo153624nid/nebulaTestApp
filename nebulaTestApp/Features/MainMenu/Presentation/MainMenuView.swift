//
//  MainMenuView.swift
//  nebulaTestApp
//
//  Created by A Ch on 18.06.2026.
//

import SwiftUI

/// Root view for MainMenu module
struct MainMenuView: View {
    
    /// ViewModel
    @ObservedObject var viewModel: MainMenuViewModel
    
    /// Initialization
    ///
    /// - Parameter viewModel: view model
    init(viewModel: MainMenuViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) { // TODO: add gradient at top
            Color.background
                .ignoresSafeArea()
            
            contentView
        }
        .toolbar(.hidden, for: .tabBar) // now is allways hidden
        .onAppear {
            viewModel.perform(action: .onAppear)
        }
        .onDisappear {
            viewModel.perform(action: .onDisappear)
        }
    }
    
    private var contentView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                controlView
                    .padding(.bottom, 20)
                
                headerView
                    .padding(.bottom, 32)
                
                cardsView
                    .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
    }
    
    private var controlView: some View {
        VStack(alignment: .trailing, spacing: 0) {
            IconButton(image: CommonImages.MainMenu.settings.swiftUIImage,
                       color: .accent.opacity(0.4),
                       size: 28) {
                viewModel.perform(action: .settingsButtonClicked)
            }
                       .padding(.all, 6)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    private var headerView: some View {
        VStack(spacing: 20) {
            CommonImages.MainMenu.stars.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            
            Text(Str.MainMenu.header)
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(Color.textAccent)
                .multilineTextAlignment(.center)
            
            chatButtonView
        }
        .frame(maxWidth: .infinity)
    }
    
    private var chatButtonView: some View {
        Button {
            viewModel.perform(action: .chatButtonClicked)
        } label: {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [
                                .accentGradientStart.opacity(0.7),
                                .accentGradientEnd.opacity(0.7)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 56)
                    .clipShape(RoundedCorners(radius: 24))
                
                Color.card
                    .frame(height: 52)
                    .clipShape(RoundedCorners(radius: 24))
                
                HStack(spacing: 16) {
                    CommonImages.MainMenu.smallStars.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.accent)
                        .frame(width: 24, height: 24)
                    
                    Text(Str.MainMenu.chatButtonTitle)
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(Color.textAccent.opacity(0.4))
                }
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(AlphaWhenPressedButtonStyle())
    }
    
    private var cardsView: some View {
        HStack(spacing: 8) {
            videoGenButton
            
            VStack(spacing: 8) {
                extraCard(icon: CommonImages.MainMenu.magicPencil.swiftUIImage,
                          title: Str.MainMenu.WritingButton.title,
                          desc: Str.MainMenu.WritingButton.desc,
                          action: { viewModel.perform(action: .fixWritingButtonClicked) })
                
                extraCard(icon: CommonImages.MainMenu.magicPrompt.swiftUIImage,
                          title: Str.MainMenu.UnderstandButton.title,
                          desc: Str.MainMenu.UnderstandButton.desc,
                          action: { viewModel.perform(action: .understandButtonClicked) })
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private var videoGenButton: some View {
        Button {
            viewModel.perform(action: .videoButtonClicked)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.05))
                        
                    CommonImages.MainMenu.imageToImage.swiftUIImage
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.accent)
                        .frame(width: 20, height: 20)
                }
                .frame(width: 36, height: 36)
                .padding(.top, 10)
                .padding(.bottom, 16)
                
                // Title
                Text(Str.MainMenu.VideoButton.title)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.textAccent)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 10)
                
                // Description
                Text(Str.MainMenu.VideoButton.desc)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.textAccent.opacity(0.4))
                    .lineLimit(1)
                
                Spacer(minLength: 26)
                
                // Footer
                ZStack {
                    Color.accent
                        .opacity(0.3)
                        .clipShape(RoundedCorners(radius: 24))
                    
                    HStack(spacing: 8) {
                        Text(Str.MainMenu.VideoButton.footer)
                            .font(.system(size: 12, weight: .regular))
                            .foregroundStyle(Color.textAccent)
                            .lineLimit(1)
                        
                        CommonImages.MainMenu.play.swiftUIImage
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(Color.accent)
                            .frame(width: 10, height: 10)
                            .padding(.all, 3)
                    }
                }
                .frame(height: 32)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 4)
            }
            .padding(.all, 16)
            .frame(height: 313)
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .background(
                ZStack {
                    LinearGradient(
                        colors: [
                            .accentGradientStart.opacity(0.7),
                            .accentGradientEnd.opacity(0.7)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    CommonImages.MainMenu.curve.swiftUIImage
                        .resizable()
                        .scaledToFill()
                }
            )
            .clipShape(RoundedCorners(radius: 24))
        }
        .buttonStyle(AlphaWhenPressedButtonStyle())
    }
    
    private func extraCard(icon: Image,
                           title: String,
                           desc: String,
                           action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(Color.accent.opacity(0.05))
                        
                    icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                .frame(width: 36, height: 36)
                
                Spacer(minLength: 8)
                
                // Title
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.textAccent)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 8)
                
                // Description
                Text(desc)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.textAccent.opacity(0.4))
                    .lineLimit(1)
            }
            .padding(.all, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.card.opacity(0.7))
            .clipShape(RoundedCorners(radius: 24))
        }
        .buttonStyle(AlphaWhenPressedButtonStyle())
    }
  
}

#Preview {
    MainMenuView(
        viewModel: MainMenuViewModel(
            coordinator: HomeTabCoordinator(parent: AppRootCoordinator())
        )
    )
}
