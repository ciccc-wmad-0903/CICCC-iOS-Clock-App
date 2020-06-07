//
//  MainClockFaceView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-07.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

fileprivate var viewSize: CGSize = .zero

class MainClockFaceView: UIView {
    
    var mainHandLayer: CALayer!
    var lapHandLayer: CALayer!
    
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
        let instanceWidth: CGFloat = 2.3
        let startX = rect.midX - instanceWidth / 2
        
        let replicatorLayer0_25 = CAReplicatorLayer()
        replicatorLayer0_25.frame = rect
        replicatorLayer0_25.instanceCount = 240
        replicatorLayer0_25.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 120), 0, 0, 1)
        layer.addSublayer(replicatorLayer0_25)
        
        let instanceLayer0_25 = CALayer()
        instanceLayer0_25.frame = CGRect(x: startX, y: 0, width: instanceWidth, height: 8)
        instanceLayer0_25.backgroundColor = UIColor.analogClockGrayColor.cgColor
        replicatorLayer0_25.addSublayer(instanceLayer0_25)
        
        let replicatorLayer1 = CAReplicatorLayer()
        replicatorLayer1.frame = rect
        replicatorLayer1.instanceCount = 60
        replicatorLayer1.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 30), 0, 0, 1)
        layer.addSublayer(replicatorLayer1)

        let instanceLayer1 = CALayer()
        instanceLayer1.frame = CGRect(x: startX, y: 0, width: instanceWidth, height: 16)
        instanceLayer1.backgroundColor = UIColor.analogClockGrayColor.cgColor
        replicatorLayer1.addSublayer(instanceLayer1)
        
        let replicatorLayer5 = CAReplicatorLayer()
        replicatorLayer5.frame = rect
        replicatorLayer5.instanceCount = 12
        replicatorLayer5.instanceTransform = CATransform3DMakeRotation(CGFloat(Double.pi / 6), 0, 0, 1)
        layer.addSublayer(replicatorLayer5)
        
        let instanceLayer5 = CALayer()
        instanceLayer5.frame = CGRect(x: startX, y: 0, width: instanceWidth, height: 16)
        instanceLayer5.backgroundColor = UIColor.white.cgColor
        replicatorLayer5.addSublayer(instanceLayer5)
        
        let radius = rect.width / 2 - 38
        let numRect = CGRect(x: 38, y: 50, width: radius * 2, height: radius * 2)
        for i in 1...12 {
            let x = numRect.midX + CGFloat(sin(Double.pi / 6.0 * Double(i))) * radius - 20
            let y = numRect.midY - CGFloat(cos(Double.pi / 6.0 * Double(i))) * radius - 30
            let numLayer = CATextLayer()
            numLayer.string = "\(i * 5)"
            numLayer.font = UIFont.systemFont(ofSize: 0, weight: .regular)
            numLayer.fontSize = 30
            numLayer.alignmentMode = .center
            numLayer.foregroundColor = UIColor.white.cgColor
            numLayer.frame = CGRect(x: x, y: y, width: 40, height: 35)
            layer.addSublayer(numLayer)
        }
    }
    
    private func drawHands(_ rect: CGRect) {
        let instanceWidth: CGFloat = 2.3
        
        mainHandLayer = CALayer()
        mainHandLayer.backgroundColor = UIColor.mainTintColor.cgColor
        mainHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.825)
        mainHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        mainHandLayer.bounds = CGRect(x: 0, y: 0, width: instanceWidth, height: rect.size.height / 2 * 1.21)
        
        lapHandLayer = CALayer()
        lapHandLayer.backgroundColor = UIColor.analogClockLapHandColor.cgColor
        lapHandLayer.anchorPoint = CGPoint(x: 0.5, y: 0.825)
        lapHandLayer.position = CGPoint(x: rect.size.width / 2, y: rect.size.height / 2)
        lapHandLayer.bounds = CGRect(x: 0, y: 0, width: instanceWidth, height: rect.size.height / 2 * 1.21)
        
        let radius:CGFloat = 4.5
        let centerCircleLayer = CALayer()
        centerCircleLayer.frame = CGRect(x: rect.midX - radius, y: rect.midY - radius, width: radius * 2, height: radius * 2)
        centerCircleLayer.cornerRadius = radius
        centerCircleLayer.backgroundColor = UIColor.black.cgColor
        centerCircleLayer.borderColor = UIColor.mainTintColor.cgColor
        centerCircleLayer.borderWidth = radius / 2
        
        layer.addSublayer(lapHandLayer)
        layer.addSublayer(mainHandLayer)
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
