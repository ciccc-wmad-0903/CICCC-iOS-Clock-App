//
//  SubClockFaceView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-07.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

fileprivate var viewSize: CGSize = .zero

class SubClockFaceView: UIView {

    var handLayer: CALayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewProperties()
    }
    
    convenience init(size: CGSize) {
        viewSize = size
        self.init()
    }
    
    override func draw(_ rect: CGRect) {
        drawClockFace(rect)
        drawHands(rect)
    }
    
    private func drawClockFace(_ rect: CGRect) {
        let instanceWidth: CGFloat = 1.7
        let startX = rect.midX - instanceWidth / 2
        
        let replicatorLayer0_5 = CAReplicatorLayer()
        replicatorLayer0_5.frame = rect
        replicatorLayer0_5.instanceCount = 60
        replicatorLayer0_5.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 30), 0, 0, 1)
        layer.addSublayer(replicatorLayer0_5)
        
        let instanceLayer0_5 = CALayer()
        instanceLayer0_5.frame = CGRect(x: startX, y: 0, width: instanceWidth, height: 6)
        instanceLayer0_5.backgroundColor = UIColor.analogClockGrayColor.cgColor
        replicatorLayer0_5.addSublayer(instanceLayer0_5)
        
        let replicatorLayer1 = CAReplicatorLayer()
        replicatorLayer1.frame = rect
        replicatorLayer1.instanceCount = 30
        replicatorLayer1.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 15), 0, 0, 1)
        layer.addSublayer(replicatorLayer1)

        let instanceLayer1 = CALayer()
        instanceLayer1.frame = CGRect(x: startX, y: 0, width: instanceWidth, height: 10)
        instanceLayer1.backgroundColor = UIColor.analogClockGrayColor.cgColor
        replicatorLayer1.addSublayer(instanceLayer1)
        
        let replicatorLayer5 = CAReplicatorLayer()
        replicatorLayer5.frame = rect
        replicatorLayer5.instanceCount = 6
        replicatorLayer5.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 3), 0, 0, 1)
        layer.addSublayer(replicatorLayer5)
        
        let instanceLayer5 = CALayer()
        instanceLayer5.frame = CGRect(x: startX, y: 0, width: instanceWidth, height: 10)
        instanceLayer5.backgroundColor = UIColor.white.cgColor
        replicatorLayer5.addSublayer(instanceLayer5)
        
        let radius = rect.width / 2 - 22.5
        let numRect = CGRect(x: 22.5, y: 24, width: radius * 2, height: radius * 2)
        for i in 1...6 {
            let x = numRect.midX + CGFloat(sin(Double.pi / 3.0 * Double(i))) * radius - 10
            let y = numRect.midY - CGFloat(cos(Double.pi / 3.0 * Double(i))) * radius - 10
            let numLayer = CATextLayer()
            numLayer.string = "\(i * 5)"
            numLayer.font = UIFont.systemFont(ofSize: 0, weight: .semibold)
            numLayer.fontSize = 16.5
            numLayer.alignmentMode = .center
            numLayer.foregroundColor = UIColor.white.cgColor
            numLayer.frame = CGRect(x: x, y: y, width: 20, height: 16.5)
            layer.addSublayer(numLayer)
        }
    }
    
    private func drawHands(_ rect: CGRect) {
        let instanceWidth: CGFloat = 2.5
        
        handLayer = CALayer()
        handLayer.backgroundColor = UIColor.mainTintColor.cgColor
        handLayer.anchorPoint = CGPoint(x: 0.5, y: 1)
        handLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        handLayer.bounds = CGRect(x: 0, y: 0, width: instanceWidth, height: rect.size.height / 2)
        
        let radius:CGFloat = 4
        let centerCircleLayer = CALayer()
        centerCircleLayer.frame = CGRect(x: rect.midX - radius, y: rect.midY - radius, width: radius * 2, height: radius * 2)
        centerCircleLayer.cornerRadius = radius
        centerCircleLayer.backgroundColor = UIColor.mainTintColor.cgColor
        
        layer.addSublayer(handLayer)
        layer.addSublayer(centerCircleLayer)
    }
    
    private func setupViewProperties() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
