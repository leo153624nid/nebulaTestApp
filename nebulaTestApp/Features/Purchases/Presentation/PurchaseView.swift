//
//  PurchaseView.swift
//  nebulaTestApp
//
//  Created by A Ch on 22.06.2026.
//

import ApphudSDK
import SwiftUI

/// Purchases screen.
struct PurchaseView: View {
    /// Model.
    @ObservedObject var viewModel: PurchaseViewModel
    
    /// Initialization.
    ///
    /// - Parameter viewModel: model for view.
    init(viewModel: PurchaseViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(Color.background)
            
            if !viewModel.paywallCfg.isEmpty {
                
                purchaseView(viewModel.paywallCfg)
                    .transition(.opacity)
                
            } else {
                
                placeholderView
                    .transition(.opacity)
                
            }
        }
        .onAppear {
            viewModel.perform(action: .viewAppear)
        }
        .onDisappear {
            viewModel.perform(action: .viewDisappear)
        }
        .animation(.easeInOut, value: viewModel.paywallCfg.isEmpty)
    }
    
    private func purchaseView(_ paywallCfg: [ApphudProduct]) -> some View { // TODO
        Text("Products: \(paywallCfg.count)")
        
//        AdaptyPaywallView(paywallConfiguration: paywallCfg,
//                          didAppear: { [weak viewModel] in
//                              viewModel?.paywallDidAppear()
//                          },
//                          didPerformAction: { [weak viewModel] action in
//                              viewModel?.paywall(didPerform: action)
//                          },
//                          didSelectProduct: { [weak viewModel] product in
//                              viewModel?.paywall(didSelectProduct: product)
//                          },
//                          didStartPurchase: { [weak viewModel] product in
//                              viewModel?.paywall(didStartPurchase: product)
//                          },
//                          didFinishPurchase: { [weak viewModel] product, result in
//                              viewModel?.paywall(didFinishPurchase: product, purchaseResult: result)
//                          },
//                          didFailPurchase: { [weak viewModel] product, error in
//                              viewModel?.paywall(didFailPurchase: product, error: error)
//                          },
//                          didStartRestore: { [weak viewModel] in
//                              viewModel?.paywallDidStartRestore()
//                          },
//                          didFinishRestore: { [weak viewModel] profile in
//                              viewModel?.paywall(didFinishRestoreWith: profile)
//                          },
//                          didFailRestore: { [weak viewModel] error in
//                              viewModel?.paywall(didFailRestoreWith: error)
//                          },
//                          didFailRendering: { [weak viewModel] error in
//                              viewModel?.paywall(didFailRendering: error)
//                          })
//        .onDisappear { [weak viewModel] in // because `didDisappear` doesn't work in this view
//            viewModel?.paywallDidDisappear()
//        }
    }
    
    private var placeholderView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .controlSize(.large)
            .tint(.accent)
    }
    
}
