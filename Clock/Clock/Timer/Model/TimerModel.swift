//
//  Timer.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

struct TimerModel: Codable, Equatable {
    var status: TimerStatus = .stop
    var base: Date?
    var pauseStart: Date?
    var timer: TimeInterval?
}

enum TimerStatus: Int, Codable {
    case start, stop, pause
}
