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
    
    private let tabbarStandartVisibility: Visibility = { // Fix differents between showing tabbar in ios 18 and lower
        if #available(iOS 18.0, *) {
            .automatic
        } else {
            .visible
        }
    }()
    
    /// Initialization
    ///
    /// - Parameter viewModel: view model
    init(viewModel: MainMenuViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.background
                .ignoresSafeArea()
            
            contentView
        }
        .toolbar(true ? .hidden : tabbarStandartVisibility, // TODO: now is allways hidden
                 for: .tabBar)
        .onAppear {
            viewModel.perform(action: .onAppear)
        }
        .onDisappear {
            viewModel.perform(action: .onDisappear)
        }
    }
    
    private var contentView: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.sections, id: \.identifier) {
                    sectionView($0)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 40)
        }
        .animation(.easeInOut, value: viewModel.sections)
    }
    
    private func sectionView(_ section: MainMenuViewModel.Section) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            switch section.identifier {
            case .main:
                mainSectionView(section: section)
            case .survey:
                ForEach(section.items, id: \.rawValue) { item in
                    itemView(item,
                             from: section)
                }
                .padding(.top, 20)
            case .more:
                Text(section.header ?? "")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(Color.textPrimary)
                    .padding(.top, 20)
                    .padding(.bottom, 4)
                
                ForEach(section.items, id: \.rawValue) {
                    itemView($0,
                             from: section)
                }
            }
        }
    }
    
    private func mainSectionView(section: MainMenuViewModel.Section) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            let firstVerticalItem = section.verticalSectionItems.first ?? .exam
            let secondVerticalItem = section.verticalSectionItems.last ?? .exam
            
            ForEach(section.items, id: \.rawValue) { item in
                if item == firstVerticalItem && section.hasTwoVerticalCells {
                    HStack(spacing: 12) {
                        itemView(firstVerticalItem,
                                 from: section)
                        
                        itemView(secondVerticalItem,
                                 from: section)
                    }
                } else if item == secondVerticalItem && section.hasTwoVerticalCells {
                    // returns an empty view to avoid duplication vertical views
                    EmptyView()
                } else {
                    itemView(item,
                             from: section)
                }
            }
        }
    }
    
    @ViewBuilder
    private func itemView(_ item: MainMenuViewModel.SectionItem,
                          from section: MainMenuViewModel.Section) -> some View {
        Button {
            viewModel.perform(action: .sectionItemTapped(item))
        } label: {
            switch item {
            case .learning:
//                MainMenuLearningCell(subtitle: viewModel.learningSubtitle,
//                                     dailyStreak: viewModel.dailyStreak ?? 0,
//                                     completedQuestions: viewModel.completedQuestions ?? 0,
//                                     totalQuestions: viewModel.totalQuestions ?? 0,
//                                     avatar: viewModel.avatar,
//                                     onDailyStreakTapped: { viewModel.perform(action: .dailyStreakTapped) })
                Text("Chat") // TODO
            case .exam:
//                if section.verticalSectionItems.contains(.exam) {
//                    MainMenuVerticalCell(item: item)
//                } else {
//                    MainMenuHorizontalCell(item: item)
//                }
                Text("Video generator") // TODO
            }
        }
//        .buttonStyle(AlphaWhenPressedButtonStyle()) // TODO
        .frame(maxWidth: .infinity, alignment: .leading)
    }
  
}

#Preview {
    MainMenuView(
        viewModel: MainMenuViewModel(
            coordinator: HomeTabCoordinator(parent: AppRootCoordinator())
        )
    )
}
