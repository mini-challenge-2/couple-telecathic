//
//  couple_telecathicApp.swift
//  couple-telecathic
//
//  Created by Michael Eko on 29/05/24.
//

import SwiftUI
import SwiftData

import UserNotifications

@main
struct couple_telecathicApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var locationManager = LocationManager()
    var container: ModelContainer

    init() {
        do {
            container = try ModelContainer(for: Item.self, User.self, SpecialDay.self)
        } catch {
            fatalError("Failed to configure SwiftData container.")
        }
    }

    var body: some Scene {
        WindowGroup {
            SignInView()
        }
        .modelContainer(container)
        .environment(\.modelContext, container.mainContext)
        .environment(locationManager)
        .environmentObject(Partner())
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
      func application(_ application: UIApplication,
                       didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
          UNUserNotificationCenter.current().delegate = self
          
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

        return true
      }


    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let tokenString = tokenParts.joined()
            print("APNs token retrieved: \(tokenString)")
        
            // Store the token in UserDefaults
            UserDefaults.standard.set(tokenString, forKey: "deviceToken")
        }
        
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error.localizedDescription)")
    }
    
}
