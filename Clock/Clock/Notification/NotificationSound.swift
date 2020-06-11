//
//  Sound.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-10.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation

class NotificationSound {
    
    private static let defaultSoundName = "Radar"
    private static let soundExtension = "caf"
    private static let classicSoundPrefix = "C_"
    private static let maxNumberOfClassic = 1000
    
    static var defaultID: Int { get { maxNumberOfClassic } }
    
    static var defaultName: String { get { getSoundName(index: defaultID) ?? defaultSoundName } }
    
    static func getID(selectedIndex: Int, isClassic: Bool) -> Int {
        return isClassic ? selectedIndex : selectedIndex + maxNumberOfClassic
    }
    
    static func getSoundFileName(index: Int?) -> String? {
        guard let index = index else { return nil }
        return index < maxNumberOfClassic ? rawSoundClassic[index] : rawSound[index - maxNumberOfClassic]
    }
    
    static func getSoundName(index: Int?) -> String? {
        guard let index = index else { return nil }
        return index < maxNumberOfClassic ? soundClassic[index] : sound[index - maxNumberOfClassic]
    }
    
    static var sound: [String] {
        get {
            let displaySound = rawSound.map { String($0.prefix(upTo: $0.lastIndex(of: ".")!)) }
                .map { $0.replacingOccurrences(of: "_", with: " ") }
            return displaySound
        }
    }
    
    static var soundClassic: [String] {
        get {
            let displaySoundClassic = rawSoundClassic.map { $0.prefix(upTo: $0.lastIndex(of: ".")!) }
                .map { String($0.suffix(from: $0.index($0.startIndex, offsetBy: 2))) }
                .map { $0.replacingOccurrences(of: "_", with: " ") }
            return displaySoundClassic
        }
    }
    
    private static var _cafContents: [String]?
    private static var cafContents: [String] {
        get {
            if let cafContents = _cafContents { return cafContents } else {
                if let contents = try? FileManager.default.contentsOfDirectory(at: Bundle.main.bundleURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                    _cafContents = contents.map { $0.lastPathComponent }.filter { $0.hasSuffix(soundExtension) }
                    return _cafContents!
                } else {
                    return []
                }
            }
        }
    }
    
    private static var rawSound: [String] {
        get {
            var ringtones = cafContents.filter { !$0.hasPrefix(classicSoundPrefix) }.sorted()
            for (index, name) in ringtones.enumerated() {
                if name.elementsEqual("\(defaultSoundName).\(soundExtension)") {
                    ringtones.insert(ringtones.remove(at: index), at: 0)
                    break
                }
            }
            return ringtones
        }
    }
    
    private static var rawSoundClassic: [String] {
        get {
            let ringtones = cafContents.filter { $0.hasPrefix(classicSoundPrefix) }.sorted()
            return ringtones
        }
    }
    
}
