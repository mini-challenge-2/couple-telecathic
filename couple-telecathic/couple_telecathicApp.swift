//
//  couple_telecathicApp.swift
//  couple-telecathic
//
//  Created by Michael Eko on 29/05/24.
//

import SwiftUI
import SwiftData
import SwiftUI
//import FirebaseCore
//import Firebase
//import FirebaseMessaging
import UserNotifications

@main
struct couple_telecathicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var locationManager = LocationManager()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            SpecialDay.self,
            User.self
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
            SignInView()
            //MainView()
//            if locationManager.isAuthorized {
//                MainView()
//            } else {
//                LocationDeniedView()
//            }
            
        
        }
        .modelContainer(sharedModelContainer)
//        .modelContainer(for: [User.self])
        .environment(locationManager)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//      FirebaseApp.configure()
      
//      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().delegate = self
      
      print(application)
      
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ success, error in
          if success {
              print("Success in APNS Registry")
          } else if let error = error {
              print("APNS Authorization error: \(error.localizedDescription)")
          } else {
              print("APNS Authorization denied")
          }
          
          print("Success in APNS Registry")
      }
      
      application.registerForRemoteNotifications()
      print("Requested APNS registration")

    return true
  }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let tokenString = tokenParts.joined()
//            Messaging.messaging().apnsToken = deviceToken
            print("APNs token retrieved: \(tokenString)")
        }
        
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error.localizedDescription)")
    }
        
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        print("FCM token: \(String(describing: fcmToken))")
//        messaging.token { token, error in
//            if let error = error {
//                print("Error fetching FCM token: \(error)")
//                return
//            }
//            guard let token = token else {
//                print("FCM token is nil")
//                return
//            }
//            print("Token retrieved: \(token)")
//        }
//    }
    
}
