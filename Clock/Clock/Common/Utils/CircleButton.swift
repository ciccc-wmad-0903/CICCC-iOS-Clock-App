//
//  StopwatchButton.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-05.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation
import UIKit

class CircleButton: UIButton {
    
    static let buttonDiameter = UIDevice.current.safeAreaSize!.height * 0.1
    
    var baseColor: UIColor {
        didSet { refreshButton() }
    }

    required init(title: String, baseColor: UIColor, isEnabled: Bool = true) {
        self.baseColor = baseColor
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 17)
        setTitleColor(baseColor, for: .normal)
        backgroundColor = baseColor.withAlphaComponent(0.13)
        layer.cornerRadius = CircleButton.buttonDiameter / 2
        self.isEnabled = isEnabled
        self.drawBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title, for: state)
        refreshButton()
    }
    
    open override var isHighlighted: Bool {
        didSet { backgroundColor = baseColor.withAlphaComponent(isHighlighted ? 0.105 : 0.21) }
    }
        
    open override var isEnabled: Bool {
        didSet { refreshButton() }
    }
    
    private func refreshButton() {
        setTitleColor(baseColor.withAlphaComponent(isEnabled ? 1.0 : 0.5), for: .normal)
        backgroundColor = baseColor.withAlphaComponent(isEnabled ? 0.21 : 0.105)
    }
    
    private func drawBorder() {
        let circleLayer = CAShapeLayer()
        let circleLineWidth = CircleButton.buttonDiameter * 0.04
        let circleDiameter = CircleButton.buttonDiameter * 0.92
        circleLayer.path = UIBezierPath(roundedRect: CGRect(x: circleLineWidth, y: circleLineWidth, width: circleDiameter, height: circleDiameter), cornerRadius: circleDiameter / 2).cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.black.cgColor
        circleLayer.lineWidth = circleLineWidth / 1.5
        layer.addSublayer(circleLayer)
    }
    
}
