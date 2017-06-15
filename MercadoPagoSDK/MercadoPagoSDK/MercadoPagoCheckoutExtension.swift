//
//  MercadoPagoCheckoutExtension.swift
//  MercadoPagoSDK
//
//  Created by Eden Torres on 5/31/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

extension MercadoPagoCheckout {

    public convenience init(publicKey: String, checkoutPreference: CheckoutPreference, paymentData: PaymentData, paymentResult: PaymentResult, discount: DiscountCoupon? = nil, navigationController: UINavigationController) {
        self.init(publicKey: publicKey, accessToken: "", checkoutPreference: checkoutPreference, paymentData: paymentData, paymentResult: paymentResult, discount: discount, navigationController: navigationController)
    }

    // Basic inits

    public convenience init(publicKey: String, checkoutPreference: CheckoutPreference, discount: DiscountCoupon? = nil, navigationController: UINavigationController) {
        self.init(publicKey: publicKey, accessToken: "", checkoutPreference: checkoutPreference, paymentData: nil, paymentResult: nil, discount: nil, navigationController: navigationController)
    }

    public convenience init(publicKey: String, accessToken: String, checkoutPreference: CheckoutPreference, discount: DiscountCoupon? = nil, navigationController: UINavigationController) {
        self.init(publicKey: publicKey, accessToken: accessToken, checkoutPreference: checkoutPreference, paymentData: nil, paymentResult: nil, discount: nil, navigationController: navigationController)
    }

    // Inits with paymentData

    public convenience init(publicKey: String, checkoutPreference: CheckoutPreference, paymentData: PaymentData, discount: DiscountCoupon? = nil, navigationController: UINavigationController) {
        self.init(publicKey: publicKey, accessToken: "", checkoutPreference: checkoutPreference, paymentData: paymentData, paymentResult: nil, discount: nil, navigationController: navigationController)
    }

    public convenience init(publicKey: String, accessToken: String, checkoutPreference: CheckoutPreference, paymentData: PaymentData, discount: DiscountCoupon? = nil, navigationController: UINavigationController) {
        self.init(publicKey: publicKey, accessToken: accessToken, checkoutPreference: checkoutPreference, paymentData: paymentData, paymentResult: nil, discount: nil, navigationController: navigationController)
    }

    open static func setDecorationPreference(_ decorationPreference: DecorationPreference) {
        MercadoPagoCheckoutViewModel.decorationPreference = decorationPreference
    }

    open static func setServicePreference(_ servicePreference: ServicePreference) {
        MercadoPagoCheckoutViewModel.servicePreference = servicePreference
    }

    open static func setFlowPreference(_ flowPreference: FlowPreference) {
        MercadoPagoCheckoutViewModel.flowPreference = flowPreference
    }

    open func setPaymentResultScreenPreference(_ paymentResultScreenPreference: PaymentResultScreenPreference) {
        self.viewModel.paymentResultScreenPreference = paymentResultScreenPreference
    }

    open func setReviewScreenPreference(_ reviewScreenPreference: ReviewScreenPreference) {
        self.viewModel.reviewScreenPreference = reviewScreenPreference
    }

    open static func setPaymentDataCallback(paymentDataCallback : @escaping (_ paymentData: PaymentData) -> Void) {
        MercadoPagoCheckoutViewModel.paymentDataCallback = paymentDataCallback
    }

    open static func setChangePaymentMethodCallback(changePaymentMethodCallback : @escaping () -> Void) {
        MercadoPagoCheckoutViewModel.changePaymentMethodCallback = changePaymentMethodCallback
    }

    open static func setPaymentCallback(paymentCallback : @escaping (_ payment: Payment) -> Void) {
        MercadoPagoCheckoutViewModel.paymentCallback = paymentCallback
    }

    open static func setPaymentDataConfirmCallback(paymentDataConfirmCallback : @escaping (_ paymentData: PaymentData) -> Void) {
        MercadoPagoCheckoutViewModel.paymentDataConfirmCallback = paymentDataConfirmCallback
    }

    open static func setCallback(callback : @escaping () -> Void) {
        MercadoPagoCheckoutViewModel.callback = callback
    }

    open static func setLanguage(language: Languages) {
        MercadoPagoContext.setLanguage(language: language)
    }

    open class func showPayerCostDescription() -> Bool {
        let path = MercadoPago.getBundle()!.path(forResource: "PayerCostPreferences", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        let site = MercadoPagoContext.getSite()

        if let siteDic = dictionary?.value(forKey: site) as? NSDictionary {
            if let payerCostDescription = siteDic.value(forKey: "payerCostDescription") as? Bool {
                return payerCostDescription
            }
        }

        return true
    }

    open class func showBankInterestWarning() -> Bool {
        let path = MercadoPago.getBundle()!.path(forResource: "PayerCostPreferences", ofType: "plist")
        let dictionary = NSDictionary(contentsOfFile: path!)
        let site = MercadoPagoContext.getSite()

        if let siteDic = dictionary?.value(forKey: site) as? NSDictionary {
            if let bankInsterestCell = siteDic.value(forKey: "bankInsterestCell") as? Bool {
                return bankInsterestCell
            }
        }

        return false
    }
}
