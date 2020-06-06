//
//  StopwatchButton.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-05.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class CircleButton: UIButton {
    
    static let buttonDiameter = UIDevice.current.safeAreaSize!.height * 0.1
    
    private var baseColor: UIColor

    required init(title: String, baseColor: UIColor, isEnabled: Bool = true) {
        self.baseColor = baseColor
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        setTitleColor(baseColor, for: .normal)
        backgroundColor = baseColor.withAlphaComponent(0.13)
        layer.cornerRadius = CircleButton.buttonDiameter / 2
        self.isEnabled = isEnabled
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override var isHighlighted: Bool {
        didSet {
            backgroundColor = baseColor.withAlphaComponent(isHighlighted ? 0.065 : 0.13)
        }
    }
        
    open override var isEnabled: Bool {
        didSet {
            setTitleColor(baseColor.withAlphaComponent(isEnabled ? 1.0 : 0.5), for: .normal)
            backgroundColor = baseColor.withAlphaComponent(isEnabled ? 0.13 : 0.065)
        }
    }
    
    private func drawBorder() {
        
    }
    
    override func draw(_ rect: CGRect) {
        <#code#>
    }
    
}
