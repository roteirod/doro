//
//  AppDelegate.swift
//  doro
//
//  Created by Volodymyr Davydenko on 04.05.2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        DataManager.shared.getConfigurations()
        DataManager.shared.getCurrentSession()
        
        NotificationsManager.shared.notificationCenter.delegate = self
        NotificationsManager.shared.requestAccess()
        
        if let timerViewController = TimerViewController.storyboardInstance() {
            self.window?.rootViewController = timerViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
}

