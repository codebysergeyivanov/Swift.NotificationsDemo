//
//  Notifications.swift
//  NotificationsDemo
//
//  Created by Сергей Иванов on 31.10.2020.
//

import UIKit
import UserNotifications

class NotificationsManager: NSObject, UNUserNotificationCenterDelegate {
    let notificationCenter = UNUserNotificationCenter.current()
    
    func auth() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { [unowned self] granted, error in
            print("Notification granted: \(granted)")
            self.getSettings()
        })
    }
    
    private func getSettings() {
        notificationCenter.getNotificationSettings(completionHandler: { settings in
            if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        })
    }
    
    func scheduledNotification(title: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "It is sheduled notification"
        content.sound = .default
        content.badge = 1
        
        let categoryIdentifier = "SomeActions"
        content.categoryIdentifier = categoryIdentifier
        
        let retryAction = UNNotificationAction(identifier: "retry", title: "Retry", options: [])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancel", options: [.destructive])
        let category = UNNotificationCategory(identifier: categoryIdentifier, actions: [retryAction, cancelAction], intentIdentifiers: [])
        notificationCenter.setNotificationCategories([category])
        
        if let path = Bundle.main.path(forResource: "favicon", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            do {
                let attachment = try UNNotificationAttachment(identifier: "attach", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("The attachment was not loaded")
            }
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "LocalNotification", content: content, trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: { error in
            if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("dismiss")
        case UNNotificationDefaultActionIdentifier:
            print("default")
        case "retry":
            scheduledNotification(title: "Retry")
        default:
            break
        }
    }
 
}
