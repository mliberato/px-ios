//
//  PXPaymentMethodComponent.swift
//  MercadoPagoSDK
//
//  Created by Demian Tejo on 24/11/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

open class PXPaymentMethodComponent: NSObject, PXComponentizable {
    var props: PXPaymentMethodProps

    public init(props: PXPaymentMethodProps) {
       self.props = props
    }

    func getPaymentMethodIconComponent() -> PXPaymentMethodIconComponent {
        let paymentMethodIconProps = PXPaymentMethodIconProps(paymentMethodIcon: self.props.paymentMethodIcon)
        let paymentMethodIconComponent = PXPaymentMethodIconComponent(props: paymentMethodIconProps)
        return paymentMethodIconComponent
    }

    public func render() -> UIView {
        return PXPaymentMethodComponentRenderer().render(component: self)
    }
}

open class PXPaymentMethodProps: NSObject {
    var paymentMethodIcon: UIImage?
    var amountTitle: String
    var amountDetail: String?
    var paymentMethodDescription: String?
    var paymentMethodDetail: String?
    var disclaimer: String?

    public init(paymentMethodIcon: UIImage?, amountTitle: String, amountDetail: String?, paymentMethodDescription: String?, paymentMethodDetail: String?, disclaimer: String?) {
        self.paymentMethodIcon = paymentMethodIcon
        self.amountTitle = amountTitle
        self.amountDetail = amountDetail
        self.paymentMethodDescription = paymentMethodDescription
        self.paymentMethodDetail = paymentMethodDetail
        self.disclaimer = disclaimer
    }

}
