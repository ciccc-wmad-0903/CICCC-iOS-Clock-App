//
//  Stopwatch.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation
import RxCocoa

struct Stopwatch: Codable {
    var status: StopwatchStatus = .stop
    var base: Date?
    var pauseStart: Date?
    var lapStart: Date?
    var laps = [TimeInterval]()
}

enum StopwatchStatus: Int, Codable {
    case start, stop, pause
}
