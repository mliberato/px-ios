//
//  HeaderComponent.swift
//  TestAutolayout
//
//  Created by Demian Tejo on 10/18/17.
//  Copyright © 2017 Demian Tejo. All rights reserved.
//

import UIKit

open class PXHeaderComponent: PXComponentizable {

    public func render() -> UIView {
        return PXHeaderRenderer().render(self)
    }

    var props: PXHeaderProps

    public init(props: PXHeaderProps) {
        self.props = props
    }
}

open class PXHeaderProps: NSObject {
    var labelText: NSAttributedString?
    var title: NSAttributedString
    var backgroundColor: UIColor
    var productImage: UIImage?
    var statusImage: UIImage?
    init(labelText: NSAttributedString?, title: NSAttributedString, backgroundColor: UIColor, productImage: UIImage?, statusImage: UIImage? ) {
        self.labelText = labelText
        self.title = title
        self.backgroundColor = backgroundColor
        self.productImage = productImage
        self.statusImage = statusImage
    }
}
