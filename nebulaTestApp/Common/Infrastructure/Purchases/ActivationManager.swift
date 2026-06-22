//
//  ActivationManager.swift
//  nebulaTestApp
//
//  Created by A Ch on 22.06.2026.
//

import ApphudSDK
import Combine
import Foundation

/// Manages Apphud SDK lifecycle and subscription status
@MainActor
final class ActivationManager: ObservableObject {
    
    /// Whether the user has an active subscription
    @Published private(set) var hasActiveSubscription = false
    
    /// Publisher for subscription status changes
    var hasActiveSubscriptionPublisher: AnyPublisher<Bool, Never> {
        $hasActiveSubscription.eraseToAnyPublisher()
    }
    
    /// Cached products for `main` paywall
    private(set) var paywallCfg: [ApphudProduct] = []
    
    /// Util is started.
    private var isStarted = false
    /// Util is finished activation
    private var isActivated = false
    
    init() {
        start()
    }
    
    /// Activate SDK
    func start() {
        guard !isStarted && !isActivated else {
            return
        }
        isStarted = true
        
        Apphud.start(apiKey: AppConstants.API.apphudPublicKey)
        refreshStatus()
        observeUpdates()
        
        isActivated = true
        
        /// Preloads
        preloadMainPaywallCfg()
    }
    
    /// Manually refresh subscription status (e.g. after restore)
    func refreshStatus() {
        hasActiveSubscription = Apphud.hasActiveSubscription()
    }
    
    /// Get paywall configuration
    ///
    /// - Parameter style: paywall style
    ///
    /// - Returns: paywall view configuration
    func paywallConfig(with style: PaywallStyle) async throws -> [ApphudProduct] {
        start()
        
//        let paywall = try await Adapty.getPaywall(placementId: placementID(for: style),
//                                                  locale: localeForPaywall())
//        let paywallConfig = try await AdaptyUI.getPaywallConfiguration(forPaywall: paywall)
//        
//        return paywallConfig
        
        if let paywallConfig = await Apphud.placement("main")?.paywall?.products {
            return paywallConfig
        }
        throw "Hasn't any products"
    }
    
    // MARK: - Private
    
    private func observeUpdates() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSubscriptionUpdate),
            name: Apphud.didUpdateNotification(),
            object: nil
        )
    }
    
    @objc
    private func handleSubscriptionUpdate() {
        refreshStatus()
    }
    
    private func preloadMainPaywallCfg() { // TODO
//        Task { [weak self] in
//            guard let self else { return }
//            
//            if let paywall = try? await Adapty.getPaywall(placementId: placementID(for: .sale),
//                                                          locale: localeForPaywall()) {
//                
//                let paywallConfig = try? await AdaptyUI.getPaywallConfiguration(forPaywall: paywall)
//                
//                await MainActor.run {
//                    self.paywallCfg = paywallConfig
//                }
//            }
//        }
    }
    
}
