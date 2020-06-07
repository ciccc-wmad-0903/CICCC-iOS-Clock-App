//
//  TimeInterval+string.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-06.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

extension TimeInterval {
    func toStopwatchString() -> String {
        let time = NSInteger(self)
        
        let ms = Int((self.truncatingRemainder(dividingBy: 1)) * 1000) / 10
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = time / 3600
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d.%02d", hours, minutes, seconds, ms)
        } else {
            return String(format: "%02d:%02d.%02d", minutes, seconds, ms)
        }
    }
}
