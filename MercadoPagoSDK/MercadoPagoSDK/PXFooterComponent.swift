//
//  PXFooterComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/19/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

open class PXFooterComponent: NSObject, PXComponentizable {
  var props: PXFooterProps

    public init(props: PXFooterProps) {
        self.props = props
    }

    public func render() -> UIView {
        return PXFooterRenderer().render(self)
    }
}
open class PXFooterProps: NSObject {
    var buttonAction: PXFooterAction?
    var linkAction: PXFooterAction?
    var primaryColor: UIColor?
    public init(buttonAction: PXFooterAction? = nil, linkAction: PXFooterAction? = nil, primaryColor: UIColor? = .pxBlueMp) {
        self.buttonAction = buttonAction
        self.linkAction = linkAction
        self.primaryColor = primaryColor
    }
}

open class PXFooterAction: NSObject {
    var label: String
    var action : (() -> Void)
    public init(label: String, action:  @escaping (() -> Void)) {
        self.label = label
        self.action = action
    }
}
