//
//  PurchaseViewModel.swift
//  nebulaTestApp
//
//  Created by A Ch on 22.06.2026.
//

import ApphudSDK
import Combine
import Foundation

/// Actions from purchases screen.
enum PurchaseViewAction {
    case viewAppear
    case viewDisappear
}

/// Model for purchases screen.
final class PurchaseViewModel: ViewModel {
    
    /// Callback for view disappear, false on failed to show paywall
    typealias Completion = (Bool) -> Void
    
    // MARK: - Properties
    /// Own coordinator.
    unowned let coordinator: any Coordinator
    /// Purchases service
    @Injected private var activationManager: ActivationManager
    
    /// Current paywall style.
    private let style: PaywallStyle?
    /// Skip failed state of paywall
    private let skipFailedState: Bool
    /// Callback for view disappear, false on failed to show paywall
    let completion: Completion?
    
    /// Paywall configuration
    @Published var paywallCfg: [ApphudProduct] = []

    private var state: PaywallState = .initial {
        didSet { updateViews() }
    }
    private var viewOnScreen = false
    
    // MARK: - Initialization
    /// Initialization.
    ///
    /// - Parameter coordinator: coordinator.
    convenience init(coordinator: any Coordinator) {
        self.init(coordinator: coordinator,
                  style: .main)
    }
    
    /// Initialization with paywall style.
    ///
    /// - Parameter coordinator: coordinator.
    /// - Parameter style: paywall style.
    /// - Parameter skipFail: skip failed state of paywall
    /// - Parameter completion: callback for view disappear, false on failed to show paywall
    init(coordinator: Coordinator,
         style: PaywallStyle,
         skipFail: Bool = false,
         completion: Completion? = nil) {
        self.coordinator = coordinator
        self.style = style
        self.skipFailedState = skipFail
        self.completion = completion
        
        let products = activationManager.paywallCfg
        if style == .main, !products.isEmpty {
            state = .ready(products)
        } else {
            preloadPaywall()
        }
    }
    
    // MARK: - Public methods
    /// Performing actions from view
    ///
    /// - Parameter action: view's action
    func perform(action: PurchaseViewAction) {
        switch action {
        case .viewAppear:
            // After screen appearing animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.viewOnScreen = true
                self?.updateViews()
            }
        case .viewDisappear:
            viewOnScreen = false
        }
    }
    
    // MARK: - Private methods
    
    private func preloadPaywall() {
        guard case .initial = state else { return }
        state = .loading
        
        Task { [weak self] in
            guard let self else { return }
            
            var paywallCfg: [ApphudProduct] = []
            let errorToShow: Error?
            do {
                paywallCfg = try await activationManager.paywallConfig(with: style ?? .main)
                errorToShow = nil
            } catch {
                paywallCfg = []
                errorToShow = error
            }
            
            await MainActor.run {
                if !paywallCfg.isEmpty {
                    self.state = .ready(paywallCfg)
                } else {
                    self.state = .failed(PaywallError(errorToShow ?? ""))
                }
            }
        }
    }
    
    private func updateViews() {
        guard viewOnScreen else { return }
        
        switch state {
            
        case .ready(let paywallCfg):
            self.paywallCfg = paywallCfg
            state = .shown
            
        case .failed(let error):
            if skipFailedState {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                    self?.completion?(false)
                    self?.coordinator.dismissPurchase()
                }
            } else {
                let alertItem = AlertItem.paywallErrorAlertItem(error: error) { [weak self] in
                    self?.completion?(false)
                    self?.coordinator.dismissPurchase()
                }
                coordinator.showAlert(alertItem)
            }
            
        default: break
        }
    }
    
    private func showSuccessAndClose() { // TODO
//        showSuccessSplash = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.showSuccessSplash = false
//            self.paywall(didPerform: .close)
//        }
    }
    
}

// MARK: Child types
extension PurchaseViewModel {
    /// Paywall state
    enum PaywallState {
        case initial
        case loading
        case ready([ApphudProduct])
        case failed(PaywallError)
        case shown
    }
}

// MARK: Paywall handlers
//extension PurchaseViewModel {
//    /// Handle the purchase start
//    func paywall(didStartPurchase product: any AdaptyPaywallProduct) {
//        let purchaseType = ExamInAppProductIds.purchaseType(of: product.vendorProductId)
//        RPHAnalytics.logPurchaseBuyClicked(purchaseType: purchaseType,
//                                           from: screenSource)
//    }
//    
//    /// Handle the purchase was finished
//    func paywall(
//        didFinishPurchase product: any AdaptyPaywallProduct,
//        purchaseResult: AdaptyPurchaseResult
//    ) {
//        guard purchaseResult.isPurchaseSuccess else { return }
//        
//        if let transaction = purchaseResult.sk2Transaction {
//            logTransaction(transaction,
//                           for: product)
//        }
//        
//        showSuccessAndClose()
//    }
//    
//    /// Handle the purchase error
//    func paywall(
//        didFailPurchase product: AdaptyPaywallProduct,
//        error: AdaptyError
//    ) {
//        let alertItem = AlertItem.purchasingErrorAlertItem(error: PaywallError(error))
//        coordinator.showAlert(alertItem)
//    }
//    
//    /// Handle the restore start
//    func paywallDidStartRestore() {
//        RPHAnalytics.logPurchaseRestoreClicked(from: screenSource)
//    }
//    
//    /// Handle the restore result
//    func paywall(
//        didFinishRestoreWith profile: AdaptyProfile
//    ) {
//        purchaseUtil.customerProfile = profile
//        let fullVersionProductId = purchaseUtil.fullVersionActiveAccessLevel?.vendorProductId
//        let extraHazardProductId = purchaseUtil.extraHazardActiveAccessLevel?.vendorProductId
//        
//        guard fullVersionProductId != nil, extraHazardProductId != nil else {
//            showAuthorizationView()
//            return
//        }
//        
//        if let fullVersionProductId {
//            RPHAnalytics.logPurchaseRestoreCompleted(
//                productId: fullVersionProductId,
//                purchaseType: ExamInAppProductIds.purchaseType(of: fullVersionProductId),
//                from: screenSource
//            )
//        }
//        if let extraHazardProductId {
//            RPHAnalytics.logPurchaseRestoreCompleted(
//                productId: extraHazardProductId,
//                purchaseType: ExamInAppProductIds.purchaseType(of: extraHazardProductId),
//                from: screenSource
//            )
//        }
//        
//        showSuccessAndClose()
//    }
//    
//    /// Handle the restore error
//    func paywall(
//        didFailRestoreWith error: AdaptyError
//    ) {
//        let alertItem = AlertItem.purchasingErrorAlertItem(error: PaywallError(error))
//        coordinator.showAlert(alertItem)
//    }
//    
//    /// Handle paywall disappear
//    func paywallDidDisappear() { }
//    
//    /// Handle paywall appear
//    func paywallDidAppear() { }
//    
//    /// Handle product select
//    func paywall(didSelectProduct product: AdaptyProduct) {
//        let purchaseType = ExamInAppProductIds.purchaseType(of: product.vendorProductId)
//        RPHAnalytics.logPurchaseProductClicked(purchaseType: purchaseType,
//                                               from: screenSource)
//    }
//    
//    /// Handle paywall actions
//    func paywall(
//        didPerform action: AdaptyUI.Action
//    ) {
//        if case .close = action {
//            coordinator.dismissPurchase()
//            completion?(true)
//        } else if case .openURL(let url, _) = action {
//            safariItem = .init(url: url,
//                               onClose: nil)
//        } else if case .custom("howToPay") = action {
//#if EXAM_RU
//            controller.present(MobileOperatorGuideViewController.modalViewController(), // TODO
//                               animated: true)
//#endif
//        }
//    }
//    
//    /// Handle paywall rendering error
//    func paywall(
//        didFailRendering error: AdaptyUIError
//    ) {
//        RPHAnalytics.logPurchaseCantShowScreen(from: screenSource)
//        let alertItem = AlertItem.paywallErrorAlertItem(error: error) { [weak self] in
//            self?.coordinator.dismissPurchase()
//            self?.completion?(false)
//        }
//        coordinator.showAlert(alertItem)
//    }
//    
//    /// Send transaction info to analytics
//    ///
//    /// - Parameter transaction: transaction information for a purchase
//    /// - Parameter product: purchased or restored product
//    private func logTransaction(_ transaction: Transaction, for product: any AdaptyPaywallProduct) {
//        let purchaseDate = transaction.purchaseDate
//        let isOldPurchase = abs(Date().timeIntervalSince(purchaseDate)) > 3600
//        let isPurchase: Bool
//        let isLifetime = transaction.productType == .nonConsumable || transaction.productType == .consumable
//        if isLifetime {
//            isPurchase = transaction.id == transaction.originalID && !isOldPurchase
//        } else {
//            isPurchase = !isOldPurchase
//        }
//        
//        let purchaseType = ExamInAppProductIds.purchaseType(of: product.vendorProductId)
//        if isPurchase {
//            let isTrial: Bool
//            if #available(iOS 17.2, *) {
//                isTrial = transaction.offer?.paymentMode == .freeTrial
//            } else {
//                isTrial = transaction.offerType == .introductory || transaction.offerType == .promotional
//            }
//            let price = Float(truncating: product.price as NSNumber)
//            if product.accessLevelId == PurchaseUtil.Constants.extraHazardAccessLevelID {
//                // Log upsell purchase transaction
//                RPHAnalytics.logUpsellCompleted(price: price,
//                                                currencyCode: product.currencyCode,
//                                                productId: product.vendorProductId,
//                                                productType: PurchaseUtil.Constants.extraHazardProductType,
//                                                purchaseType: purchaseType,
//                                                isTrial: isTrial,
//                                                from: screenSource)
//            } else {
//                // Log other purchase transactions
//                RPHAnalytics.logPurchaseCompleted(price: price,
//                                                  currencyCode: product.currencyCode,
//                                                  productId: product.vendorProductId,
//                                                  purchaseType: purchaseType,
//                                                  isTrial: isTrial,
//                                                  from: screenSource)
//            }
//        } else {
//            // Log restore transactions
//            RPHAnalytics.logPurchaseRestoreCompleted(productId: product.vendorProductId,
//                                                     purchaseType: purchaseType,
//                                                     from: screenSource)
//        }
//    }
//}

// MARK: - Authorization flow
//private extension PurchaseViewModel {
//    
//    /// Present authorization flow
//    func showAuthorizationView() {
//        let onFinished: (Bool) -> Void = { [weak self] isSuccess in
//            guard let self else { return }
//            
//            self.authItem = nil
//            
//            guard isSuccess else { return }
//            
//            if let fullVersionProductId = self.purchaseUtil.fullVersionActiveAccessLevel?.vendorProductId {
//                RPHAnalytics.logPurchaseRestoreCompleted(
//                    productId: fullVersionProductId,
//                    purchaseType: ExamInAppProductIds.purchaseType(of: fullVersionProductId),
//                    from: screenSource
//                )
//            }
//            if let extraHazardProductId = self.purchaseUtil.extraHazardActiveAccessLevel?.vendorProductId {
//                RPHAnalytics.logPurchaseRestoreCompleted(
//                    productId: extraHazardProductId,
//                    purchaseType: ExamInAppProductIds.purchaseType(of: extraHazardProductId),
//                    from: screenSource
//                )
//            }
//            
//            showSuccessAndClose()
//        }
//        let onSupport: () -> Void = { [weak self] in
//            guard let self else { return }
//            
//            if MFMailComposeViewController.canSendMail() {
//                let profileId = purchaseUtil.customerProfile?.profileId ?? ""
//                let mailItem = MailCoordinatorItem.supportItem(profileId: profileId) { isSent in
//                    if isSent {
//                        RPHAnalytics.incWritedToSuportUserAttribute()
//                    }
//                }
//                self.mailItem = mailItem
//            } else {
//                self.coordinator.showAlert(.cantSendEmailAlertItem())
//            }
//        }
//        
//        authItem = AuthCoordinatorItem(onFinished: onFinished,
//                                       onSupport: onSupport)
//    }
//}




extension String: Error {}
