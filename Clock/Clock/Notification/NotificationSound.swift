//
//  Sound.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

class NotificationSound {
    
    private static var _sound: [String]?
    private static var _soundClassic: [String]?
    private static var _displaySound: [String]?
    private static var _displaySoundClassic: [String]?

    static var sound: [String] {
        get {
            if let sound = _sound { return sound } else {
                let contents = try? FileManager.default.contentsOfDirectory(at: Bundle.main.bundleURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                if let contents = contents {
                    let ringtones = contents.map { $0.lastPathComponent }.filter { $0.hasSuffix("caf")}.filter { !$0.hasPrefix("C_") }
                    _sound = ringtones
                    return ringtones
                } else {
                    _sound = nil
                    return []
                }
            }
        }
    }
    
    static var soundClassic: [String] {
        get {
            if let soundClassic = _soundClassic { return soundClassic } else {
                let contents = try? FileManager.default.contentsOfDirectory(at: Bundle.main.bundleURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
                if let contents = contents {
                    let ringtones = contents.map { $0.lastPathComponent }.filter { $0.hasSuffix("caf") }.filter { $0.hasPrefix("C_") }
                    _soundClassic = ringtones
                    return ringtones
                } else {
                    _soundClassic = nil
                    return []
                }
            }
        }
    }
    
    static var displaySound: [String] {
        get {
            if let displaySound = _displaySound { return displaySound } else {
                let displaySound = sound.map { String($0.prefix(upTo: $0.lastIndex(of: ".")!)) }
                    .map { $0.replacingOccurrences(of: "_", with: " ") }
                _displaySound = displaySound
                return displaySound
            }
        }
    }
    
    static var displaySoundClassic: [String] {
        get {
            if let displaySoundClassic = _displaySoundClassic { return displaySoundClassic } else {
                let displaySoundClassic = soundClassic.map { $0.prefix(upTo: $0.lastIndex(of: ".")!) }
                    .map { String($0.suffix(from: $0.index($0.startIndex, offsetBy: 2))) }
                    .map { $0.replacingOccurrences(of: "_", with: " ") }
                _displaySoundClassic = displaySoundClassic
                return displaySoundClassic
            }
        }
    }
    
}
