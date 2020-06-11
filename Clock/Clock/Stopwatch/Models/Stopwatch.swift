//
//  Stopwatch.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

struct Stopwatch: Codable, Equatable {
    var status: StopwatchStatus = .stop
    var base: Date?
    var pauseStart: Date?
    var lapStart: Date?
    var laps = [Lap]()
}

struct Lap: Codable, Equatable {
    var lap: TimeInterval
    var lapString: String
    var min = false, max = false
    
    init(lap: TimeInterval) {
        self.lap = lap
        self.lapString = lap.toStopwatchString()
    }
}

enum StopwatchStatus: Int, Codable {
    case start, stop, pause
}
