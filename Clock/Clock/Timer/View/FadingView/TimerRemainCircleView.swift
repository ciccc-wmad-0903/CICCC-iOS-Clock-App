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
    
    lazy var remainDigitLabel = TimerRemainDigitLabel()
    lazy var dueTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .timerLightGrayColor
        label.font = .monospacedDigitSystemFont(ofSize: 18, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    private var remainingCircle: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewProperties()
        setupRemainDigitLabel()
        setupDueTimeLabel()
    }
    
    convenience init(size: CGSize) {
        viewSize = size
        self.init()
    }
    
    func setDueTimeLabelText(dueTime: String) {
        dueTimeLabel.text = "🔔 \(dueTime)"
    }
    
    func isDueTimePaused(isPaused: Bool) {
        dueTimeLabel.textColor = isPaused ? UIColor.timerDarkGrayColor : UIColor.timerLightGrayColor
    }
    
    func setRemainDigitLabelText(remainDigit: String) {
        if remainDigit.count > 5 {
            remainDigitLabelLeadingConstraintWith60?.isActive = false
            remainDigitLabelTrailingConstraintWith60?.isActive = false
            remainDigitLabelLeadingConstraintWith35?.isActive = true
            remainDigitLabelTrailingConstraintWith35?.isActive = true
        } else {
            remainDigitLabelLeadingConstraintWith35?.isActive = false
            remainDigitLabelTrailingConstraintWith35?.isActive = false
            remainDigitLabelLeadingConstraintWith60?.isActive = true
            remainDigitLabelTrailingConstraintWith60?.isActive = true
        }
        remainDigitLabel.text = remainDigit
    }
    
    func setRemainingCircle(percent: CGFloat) {
        if percent >= 0 && percent <= 100 {
            CALayer.performWithoutAnimation {
                remainingCircle?.strokeEnd = percent
            }
        }
    }
    
    private func setupViewProperties() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDueTimeLabel() {
        addSubview(dueTimeLabel)
        dueTimeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dueTimeLabel.topAnchor.constraint(equalTo: remainDigitLabel.bottomAnchor).isActive = true
    }
    
    private var remainDigitLabelLeadingConstraintWith35: NSLayoutConstraint?
    private var remainDigitLabelLeadingConstraintWith60: NSLayoutConstraint?
    private var remainDigitLabelTrailingConstraintWith35: NSLayoutConstraint?
    private var remainDigitLabelTrailingConstraintWith60: NSLayoutConstraint?
    
    private func setupRemainDigitLabel() {
        addSubview(remainDigitLabel)
        remainDigitLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -viewSize.height * 0.05).isActive = true
        remainDigitLabelLeadingConstraintWith35 = remainDigitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35)
        remainDigitLabelTrailingConstraintWith35 = remainDigitLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35)
        remainDigitLabelLeadingConstraintWith60 = remainDigitLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 60)
        remainDigitLabelTrailingConstraintWith60 = remainDigitLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -60)
        remainDigitLabelLeadingConstraintWith60?.isActive = true
        remainDigitLabelTrailingConstraintWith60?.isActive = true
    }
    
    override func draw(_ rect: CGRect) {
        let bgCircleLayer = CAShapeLayer()
        bgCircleLayer.path = UIBezierPath(arcCenter: .init(x: rect.size.width / 2, y: rect.size.height / 2), radius: rect.size.height / 2, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true).cgPath
        bgCircleLayer.fillColor = UIColor.clear.cgColor
        bgCircleLayer.strokeColor = UIColor.timerDarkGrayColor.cgColor
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
