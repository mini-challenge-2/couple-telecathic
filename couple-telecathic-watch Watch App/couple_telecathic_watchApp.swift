//
//  couple_telecathic_watchApp.swift
//  couple-telecathic-watch Watch App
//
//  Created by Liefran Satrio Sim on 04/06/24.
//

import SwiftUI
import UserNotifications
import SwiftData
import WatchKit

@main
struct couple_telecathic_watch_Watch_AppApp: App {
    @WKExtensionDelegateAdaptor(ExtensionDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class NotificationController: WKUserNotificationInterfaceController {
    
    override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    override func didReceive(_ notification: UNNotification) {
        // Handle the notification when it is received
    }
}

extension NotificationController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification when the app is in the foreground
        completionHandler([.alert, .sound, .badge, .banner])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the user's response to the notification
        completionHandler()
    }
}

class ExtensionDelegate: NSObject, WKExtensionDelegate, UNUserNotificationCenterDelegate {

    func applicationDidFinishLaunching() {
           // Set the delegate for UNUserNotificationCenter
           UNUserNotificationCenter.current().delegate = self
           
           // Request authorization to display notifications
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
               if granted {
                   print("Notification authorization granted")
               } else if let error = error {
                   print("Notification authorization error: \(error.localizedDescription)")
               } else {
                   print("Notification authorization denied")
               }
           }
           
           WKExtension.shared().registerForRemoteNotifications()
       }

       func didRegisterForRemoteNotifications(withDeviceToken deviceToken: Data) {
           let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
           let tokenString = tokenParts.joined()
           print("APNs token retrieved: \(tokenString)")
           
           // Store the token in UserDefaults
           UserDefaults.standard.set(tokenString, forKey: "deviceToken")
       }
       
       func didFailToRegisterForRemoteNotificationsWithError(_ error: Error) {
           print("Failed to register for remote notifications with error: \(error.localizedDescription)")
       }

       func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   willPresent notification: UNNotification,
                                   withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
           // Handle the notification when the app is in the foreground
           completionHandler([.alert, .sound, .badge])
       }

       func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
           // Handle the user's response to the notification
           completionHandler()
       }
}
