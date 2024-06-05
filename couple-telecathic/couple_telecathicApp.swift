//
//  couple_telecathicApp.swift
//  couple-telecathic
//
//  Created by Michael Eko on 29/05/24.
//

import SwiftUI
import SwiftData
import SwiftUI
import FirebaseCore
import Firebase
import FirebaseMessaging
import UserNotifications

@main
struct couple_telecathicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            SpecialDay.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
//            SIWA()
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      
      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().delegate = self
      
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ success, _ in
          guard success else {
              return
          }
          
          print("Success in APNS Registry")
      }
      
      application.registerForRemoteNotifications()

    return true
  }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().apnsToken = deviceToken
            print("APNs token retrieved: \(deviceToken)")
        }
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            print("FCM token: \(String(describing: fcmToken))")
            messaging.token { token, error in
                if let error = error {
                    print("Error fetching FCM token: \(error)")
                    return
                }
                guard let token = token else {
                    print("FCM token is nil")
                    return
                }
                print("Token retrieved: \(token)")
            }
        }
    
}
