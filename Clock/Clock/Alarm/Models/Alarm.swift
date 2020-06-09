//
//  Alarm.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-08.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

/// Alarm Struct
///
/// - [alarm] property: Date type value for alarm time
/// - [repeatable] property: Bool array for Sunday(index: 0) ~ Saturday(index: 6)
/// - [label] property: String value for alarm label
/// - **TODO: Must be checked!** [sound] property: String value for alarm sound ID
/// - [isEnable] property: Bool value for enable/disable alarm
struct Alarm: Codable {

    static let days = [
        ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
        ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    ]
    
    static var DEFAULT_DATE: Date { get { Date() } }
    static let DEFAULT_REPEAT: [Bool] = .init(repeating: false, count: 7)
    static let DEFAULT_LABEL = "Alarm"
    static let DEFAULT_SOUND_ID = "Radar"
    
    var alarm: Date = Alarm.DEFAULT_DATE
    var repeatable: [Bool] = Alarm.DEFAULT_REPEAT
    var label: String = Alarm.DEFAULT_LABEL
    /// - **TODO: Must be checked!**
    /// > [sound] property: String value for alarm sound ID
    var sound: String = Alarm.DEFAULT_SOUND_ID
    var isEnable: Bool = true
    
    func repeatableToString() -> String {
        let trueDays = repeatable.enumerated().filter { $0.element }
        
        switch (trueDays.count) {
        case 0: return "Never"
        case 7: return "Every day"
        case 2: if repeatable[0] && repeatable[6] { return "Weekends" }
        case 5: if !(repeatable[0] || repeatable[6]) { return "Weekdays" }
        case 1: return oneDayToString(Alarm.DayIndex(rawValue: trueDays[0].offset))
        default: break
        }
        
        var startWithMonday = Alarm.days[0]
        startWithMonday.append(startWithMonday.remove(at: 0))
        return startWithMonday.enumerated()
            .filter { repeatable[($0.offset + 1) % 7] }
            .map { $0.element }
            .joined(separator: " ")
    }
    
    func oneDayToString(_ dayIndex: DayIndex?) -> String {
        guard let dayIndex = dayIndex else {
            print("[\(#file):\(#function):\(#line)] RawValue for Alarm.DayIndex out of range(should be in 0 ~ 7)")
            return "Every (nil)Day"
        }
        return "Every \(Alarm.days[1][dayIndex.rawValue])"
    }
    
    enum DayIndex: Int {
        case Sun, Mon, Tue, Wed, Thu, Fri, Sat
    }
    
}
