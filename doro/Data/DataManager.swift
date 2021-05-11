//
//  DataManager.swift
//  doro
//
//  Created by Volodymyr Davydenko on 08.05.2021.
//

import Foundation
import RealmSwift

class DataManager {
    
    static let shared = DataManager()
    
    let realm = try! Realm()
    
    var currentSession: Results<Pomodoro>?
    var savedConfigurations: Results<Configuration>?
    
    func configureSession(pomodoros: Int, focus: Double, shortBreak: Double, longBreak: Double) {
        cleanSession()

        var nextStart = Date().timeIntervalSince1970
        for index in 0..<pomodoros {
            let newPomodoro = Pomodoro()
            newPomodoro.index = index
            newPomodoro.focusDuration = focus
            newPomodoro.breakDuration = (index + 1).quotientAndRemainder(dividingBy: 4).remainder == 0 ? longBreak : shortBreak
            newPomodoro.start = nextStart
            newPomodoro.breakStart = newPomodoro.start + newPomodoro.focusDuration
            newPomodoro.end = newPomodoro.breakStart  + newPomodoro.breakDuration
            nextStart = newPomodoro.end
            
            do {
                try realm.write() {
                    realm.add(newPomodoro)
                }
            } catch {
                print(error)
            }
        }
        
        NotificationsManager.shared.addNotifications()
    }
    
    func currentSessionState(completion: @escaping(_ index: Int, _ state: SessionState, _ timeLeft: Double, _ currentProgress: Double, _ totalSpent: Double, _ totalProgress: Double) -> Void) {
        let currentTime: Double = Date().timeIntervalSince1970
        var totalSpent: Double = 0
        var totalProgress: Double = 0.0
        
        if let sessionStart = currentSession?.first?.start, let sessionEnd = currentSession?.last?.end {
            totalSpent = currentTime - sessionStart
            totalProgress = totalSpent / (sessionEnd - sessionStart)
        }
        
        if let currentPomodoro = currentSession?.filter({currentTime >= $0.start && currentTime < $0.end}).first {
            if currentTime < currentPomodoro.breakStart {
                completion(currentPomodoro.index, .inFocus, currentPomodoro.breakStart - currentTime, (currentTime - currentPomodoro.start) / currentPomodoro.focusDuration, totalSpent, totalProgress)
            } else {
                completion(currentPomodoro.index, .inBreak, currentPomodoro.end - currentTime, (currentPomodoro.end - currentTime) / currentPomodoro.breakDuration, totalSpent, totalProgress)
            }
        } else {
            completion((currentSession?.count ?? 1) - 1, .completed, 0, 0.0, totalSpent, totalProgress)
        }
    }
    
    func getConfigurations() {
        savedConfigurations = realm.objects(Configuration.self).sorted(byKeyPath: "timestamp", ascending: false)
    }
    
    func saveConfiguration(title: String, pomodoros: Int, focus: Double, shortBreak: Double, longBreak: Double) {
        let newConfiguration = Configuration()
        
        newConfiguration.timestamp = Date().timeIntervalSince1970
        newConfiguration.title = title
        newConfiguration.pomodoros = pomodoros
        newConfiguration.focusDuration = focus
        newConfiguration.shortBreakDuration = shortBreak
        newConfiguration.longBreakDuration = longBreak
        
        do {
            try realm.write {
                realm.add(newConfiguration)
            }
        } catch {
            print(error)
        }
    }
    
    func getCurrentSession() {
        currentSession = realm.objects(Pomodoro.self).sorted(byKeyPath: "index", ascending: true)

        let currentTime: Double = Date().timeIntervalSince1970
        if currentSession?.filter({currentTime >= $0.start && currentTime < $0.end}).first == nil {
            cleanSession()
        }
    }
    
    func cleanSession() {
        NotificationsManager.shared.notificationCenter.removeAllPendingNotificationRequests()
        
        do {
            try realm.write {
                let session = realm.objects(Pomodoro.self)
                realm.delete(session)
            }
        } catch {
            print(error)
        }
    }
}
