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

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViewProperties()
    }
    
    convenience init(size: CGSize) {
        viewSize = size
        self.init()
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    private func setupViewProperties() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
