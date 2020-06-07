//
//  Device+size.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-05.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

extension UIDevice {
    var safeAreaSize: CGSize? {
        return UIApplication.shared.windows.filter { $0.isKeyWindow}.first?.safeAreaLayoutGuide.layoutFrame.size
    }
}
