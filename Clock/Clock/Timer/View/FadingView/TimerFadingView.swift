//
//  FadingView.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit

class TimerFadingView: UIView {
    
    private(set) var fadingViewSize: CGSize!
    
    lazy var setTimePicker = TimerSetTimePicker()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let safeAreaSize = UIDevice.current.safeAreaSize!
        fadingViewSize = CGSize(width: safeAreaSize.width, height: safeAreaSize.height * 0.491)
        
        setupViewProperties()
        setupSetTimePicker()
    }
    
    private func setupViewProperties() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .black
    }
    
    private func setupSetTimePicker() {
        addSubview(setTimePicker)
        setTimePicker.matchParent(padding: .init(top: fadingViewSize.height / 4, left: 24, bottom: fadingViewSize.height / 4, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
