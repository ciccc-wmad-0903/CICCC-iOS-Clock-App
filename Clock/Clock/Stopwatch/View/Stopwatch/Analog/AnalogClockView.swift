//
//  AnalogClockView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-07.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

fileprivate var viewSize: CGSize = .zero

class AnalogClockView: UIView {
    
    lazy var digitalStopwatchInAnalogLabel = StopwatchDigitalLabel()
    lazy var mainAnalogClockFace = MainClockFaceView(size: viewSize)
    lazy var subAnalogClockFace = SubClockFaceView(size: CGSize(width: viewSize.width / 4, height: viewSize.height / 4))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewProperties()
        setupDigitalStopwatchView()
        setupSubClockFaceView()
        setupMainClockFaceView()
    }
    
    convenience init(size: CGSize) {
        viewSize = size
        self.init()
    }
    
    private func setupViewProperties() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupDigitalStopwatchView() {
        addSubview(digitalStopwatchInAnalogLabel)
        digitalStopwatchInAnalogLabel.font = .monospacedDigitSystemFont(ofSize: 100, weight: .regular)
        digitalStopwatchInAnalogLabel.widthAnchor.constraint(equalToConstant: viewSize.width * 0.275).isActive = true
        digitalStopwatchInAnalogLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        digitalStopwatchInAnalogLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -viewSize.height * 0.21).isActive = true
    }
    
    private func setupMainClockFaceView() {
        addSubview(mainAnalogClockFace)
        mainAnalogClockFace.matchParent()
    }
    
    private func setupSubClockFaceView() {
        addSubview(subAnalogClockFace)
        subAnalogClockFace.constraintWidth(equalToConstant: viewSize.width / 4, heightEqualToConstant: viewSize.height / 4)
        subAnalogClockFace.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        subAnalogClockFace.topAnchor.constraint(equalTo: topAnchor, constant: viewSize.height * 0.2).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
