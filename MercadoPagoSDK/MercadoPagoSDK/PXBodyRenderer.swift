//
//  PXBodyRenderer.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

class PXBodyRenderer: NSObject {

    func render(_ body: PXBodyComponent) -> PXBodyView {
        if body.hasInstructions(), let instructionsComponent = body.getInstructionsComponent() {
            return instructionsComponent.render() as! PXInstructionsView
        } else if body.props.paymentResult.isApproved() {
            return body.getPaymentMethodComponent().render() as! PXBodyView
        } else if body.hasBodyError() {
            return body.getBodyErrorComponent().render() as! PXErrorView
        }
        let bodyView = PXBodyView()
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        return bodyView
    }
}

open class PXBodyView: PXComponentView {
}
