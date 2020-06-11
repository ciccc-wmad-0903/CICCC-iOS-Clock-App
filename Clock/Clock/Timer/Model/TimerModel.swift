//
//  Timer.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

struct TimerModel: Codable, Equatable {
    var dueTime: Date?
    var pauseStart: Date?
    
    // Status
    var status: TimerStatus = .stop
    var setTime: TimeInterval = 600.0
    var soundID: Int? = NotificationSound.defaultID
}

enum TimerStatus: Int, Codable {
    case start, stop, pause
}
