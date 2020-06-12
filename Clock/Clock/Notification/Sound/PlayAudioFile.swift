//
//  PlayAudioFile.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import Foundation
import AVFoundation

var soundPlayer: AVAudioPlayer?

class PlayAudioFile {
    
    static let shared = PlayAudioFile()
    
    func playAudioFile(soundId: Int?) {
        if let soundPlayer = soundPlayer { if soundPlayer.isPlaying { soundPlayer.stop() } }
        guard let soundId = soundId else { return }
        guard let url = Bundle.main.url(forResource: String(NotificationSound.getSoundFileName(index: soundId)?.dropLast(4) ?? ""),
                                        withExtension: "caf") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)

            if #available(iOS 11.0, *) {
                soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)
            } else {
                soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.caf.rawValue)
            }

            guard let aPlayer = soundPlayer else { return }
            aPlayer.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
}
