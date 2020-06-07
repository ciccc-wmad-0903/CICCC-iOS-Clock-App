//
//  AnalogClockView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-07.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class AnalogClockView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewProperties()
    }
    
    private func setupViewProperties() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
