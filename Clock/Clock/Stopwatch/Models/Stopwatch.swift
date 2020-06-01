//
//  Stopwatch.swift
//  Clock
//
//  Created by Kaden Kim on 2020-05-31.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

struct Stopwatch: Codable {
    
    private(set) var status: Status = .stop
    private(set) var base: Date?
    private(set) var pauseStart: Date?
    private(set) var lapStart: Date?
    private(set) var laps = [TimeInterval]()
    
    var current: TimeInterval { get { base?.distance(to: Date()) ?? 0 } }
    var lapCurrent: TimeInterval { get { lapStart?.distance(to: Date()) ?? 0 } }
    
    mutating func reset() {
        status = .stop
        base = nil
        pauseStart = nil
        lapStart = nil
        laps = [TimeInterval]()
    }
    
    mutating func start() {
        if status == .stop {
            base = Date()
            lapStart = base
            status = .start
        } else if status == .pause {
            if let _ = base, let _ = lapStart, let pauseStart = pauseStart {
                let interval = pauseStart.distance(to: Date())
                base?.addTimeInterval(interval)
                lapStart?.addTimeInterval(interval)
                self.pauseStart = nil
                status = .start
            } else {
                reset()
            }
        } else {
            reset()
        }
    }
    
    mutating func stop() {
        if status == .start, pauseStart == nil {
            pauseStart = Date()
        } else {
            reset()
        }
    }
    
    mutating func lap() {
        if status == .start, let lapStart = lapStart {
            self.lapStart = Date()
            laps.append(lapStart.distance(to: self.lapStart!))
        } else {
            reset()
        }
    }
    
}

enum Status: Int, Codable {
    case start, stop, pause
}
