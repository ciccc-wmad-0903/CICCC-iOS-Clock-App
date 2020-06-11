//
//  ClockNotification.swift
//  Clock
//
//  Created by Kaden Kim on 2020-06-11.
//  Copyright © 2020 CICCC. All rights reserved.
//

import UIKit
import UserNotifications

class ClockNotification {
    
    static let shared = ClockNotification()
    
    func createNotification(id: String, interval: TimeInterval, title: String, body: String = "", soundId: Int? = nil) {
        createNotification(id: id, date: Date(timeIntervalSinceNow: interval), title: title, body: body, soundId: soundId)
    }
    
    func createNotification(id: String, date: Date, title: String, body: String = "", soundId: Int? = nil, repeats: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if let soundId = soundId, let soundName = NotificationSound.getSoundFileName(index: soundId) {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: soundName))
        }
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: repeats)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            print("NotificationCenter Error: \(error.debugDescription)")
        }
    }
    
    func cancelNotification(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
