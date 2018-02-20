//
//  PXPaymentMethodIconComponent.swift
//  MercadoPagoSDK
//
//  Created by AUGUSTO COLLERONE ALFONSO on 12/21/17.
//  Copyright © 2017 MercadoPago. All rights reserved.
//

import UIKit

open class PXPaymentMethodIconComponent: NSObject, PXComponentizable {
    var props: PXPaymentMethodIconProps

    public init(props: PXPaymentMethodIconProps) {
        self.props = props
    }
    public func render() -> UIView {
        return PXPaymentMethodIconRenderer().render(component: self)
    }
}

open class PXPaymentMethodIconProps: NSObject {
    var paymentMethodIcon: UIImage?

    public init(paymentMethodIcon: UIImage?) {
        self.paymentMethodIcon = paymentMethodIcon
    }
}
