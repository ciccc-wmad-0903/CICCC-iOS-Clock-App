//
//  stopwatchDigitalLabel.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-07.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class StopwatchDigitalLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .white
        font = .monospacedDigitSystemFont(ofSize: 100, weight: .thin)
        textAlignment = .center
        adjustsFontSizeToFitWidth = true
        allowsDefaultTighteningForTruncation = false
        minimumScaleFactor = 0.1
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
