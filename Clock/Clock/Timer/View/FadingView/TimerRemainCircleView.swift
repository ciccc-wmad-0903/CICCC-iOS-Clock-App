//
//  TimerRemainCircleView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

fileprivate var viewSize: CGSize = .zero

class TimerRemainCircleView: UIView {
    
    var remainingCircle: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewProperties()
        
    }
    
    convenience init(size: CGSize) {
        viewSize = size
        self.init()
    }
    
    private func setupViewProperties() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setRemainingCircle(percent: CGFloat) {
        CALayer.performWithoutAnimation {
            remainingCircle?.strokeEnd = percent
        }
    }
    
    override func draw(_ rect: CGRect) {
        let bgCircleLayer = CAShapeLayer()
        bgCircleLayer.path = UIBezierPath(arcCenter: .init(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        bgCircleLayer.fillColor = UIColor.clear.cgColor
        bgCircleLayer.strokeColor = UIColor.timerRemainCircleBackgroundColor.cgColor
        bgCircleLayer.lineWidth = 10.0
        bgCircleLayer.lineCap = .round
        layer.addSublayer(bgCircleLayer)
        
        
        remainingCircle = CAShapeLayer()
        remainingCircle!.path = UIBezierPath(arcCenter: .init(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2, startAngle: CGFloat(Double.pi * 3 / 2), endAngle: CGFloat(Double.pi * 7 / 2), clockwise: true).cgPath
        remainingCircle!.fillColor = UIColor.clear.cgColor
        remainingCircle!.strokeColor = UIColor.mainTintColor.cgColor
        remainingCircle!.lineWidth = 10.0
        remainingCircle!.lineCap = .round
        layer.addSublayer(remainingCircle!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
