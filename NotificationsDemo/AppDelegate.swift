//
//  AppDelegate.swift
//  NotificationsDemo
//
//  Created by Сергей Иванов on 31.10.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let notificationsManager = NotificationsManager()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        notificationsManager.notificationCenter.delegate = notificationsManager
        notificationsManager.auth()
        UIApplication.shared.applicationIconBadgeNumber = 0
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        print("Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Falil to register for remote notif: \(error.localizedDescription)")
    }

}

