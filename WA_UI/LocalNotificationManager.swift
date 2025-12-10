//
//  LocalNotificationManager.swift
//  WA_UI
//
//  Created by Balaji Sundar on 12/9/25.
//

//
//  LocalNotificationManager.swift
//  WA_UI
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    
    static let shared = LocalNotificationManager()
    
    private init() {}
    
 
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            }
        }
    }
    
    // Notification pops up once the user leaves the game
    func scheduleGameOnHoldNotification() {
        let content = UNMutableNotificationContent()
        content.title = "⏸ Game On Hold"
        content.body = "Your game is waiting for you! Tap to continue playing."
        content.sound = .default
        
        // 3 seconds hold to display notofication
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "gameOnHold", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    // Cancel notification when user returns to game
    func cancelGameNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["gameOnHold"])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: ["gameOnHold"])
    }
}
