//
//  NotificationManager.swift
//  doro
//
//  Created by Volodymyr Davydenko on 11.05.2021.
//

import Foundation
import UserNotifications

class NotificationsManager {
    
    static let shared = NotificationsManager()
    
    let notificationCenter = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]
    
    func requestAccess() {
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
        }
    }
    
    func addNotifications() {
        let session = DataManager.shared.currentSession
        session?.forEach { pomodoro in
            if pomodoro.index > 0 {
                let focusContent = UNMutableNotificationContent()
                focusContent.title = "Focus"
                focusContent.body = "Focus on your task for \(String(format: "%02d", Int(pomodoro.focusDuration).quotientAndRemainder(dividingBy: 60).quotient)):\(String(format: "%02d", Int(pomodoro.focusDuration).quotientAndRemainder(dividingBy: 60).remainder))"
                focusContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "inflicted.caf"))
                
                let focusDate = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(timeIntervalSince1970: pomodoro.start))
                let focusTrigger = UNCalendarNotificationTrigger(dateMatching: focusDate, repeats: false)
                let focusRequest = UNNotificationRequest(identifier: UUID().uuidString, content: focusContent, trigger: focusTrigger)
                
                notificationCenter.add(focusRequest) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
            }
            
            if let sessionCount = session?.count, pomodoro.index == sessionCount - 1 {
                let endContent = UNMutableNotificationContent()
                endContent.title = "Done!"
                endContent.body = "Great job! You have finished working for now"
                endContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "eventually.caf"))
                
                let endDate = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(timeIntervalSince1970: pomodoro.end))
                let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDate, repeats: false)
                let endRequest = UNNotificationRequest(identifier: UUID().uuidString, content: endContent, trigger: endTrigger)
                
                notificationCenter.add(endRequest) { (error) in
                    if let error = error {
                        print("Error \(error.localizedDescription)")
                    }
                }
            }
            
            let restContent = UNMutableNotificationContent()
            restContent.title = "Rest"
            restContent.body = "Rest for \(String(format: "%02d", Int(pomodoro.breakDuration).quotientAndRemainder(dividingBy: 60).quotient)):\(String(format: "%02d", Int(pomodoro.breakDuration).quotientAndRemainder(dividingBy: 60).remainder))"
            restContent.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "eventually.caf"))
            
            let restDate = Calendar.current.dateComponents([.hour, .minute, .second], from: Date(timeIntervalSince1970: pomodoro.breakStart))
            let restTrigger = UNCalendarNotificationTrigger(dateMatching: restDate, repeats: false)
            let restRequest = UNNotificationRequest(identifier: UUID().uuidString, content: restContent, trigger: restTrigger)
            
            notificationCenter.add(restRequest) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
}
