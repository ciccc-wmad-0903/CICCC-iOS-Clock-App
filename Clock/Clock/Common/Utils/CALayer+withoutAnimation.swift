//
//  CALayer+withoutAnimation.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-07.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

extension CALayer {
    class func performWithoutAnimation(_ actionsWithoutAnimation: () -> Void) {
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        actionsWithoutAnimation()
        CATransaction.commit()
    }
}
