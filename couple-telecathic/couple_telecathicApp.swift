//
//  couple_telecathicApp.swift
//  couple-telecathic
//
//  Created by Michael Eko on 29/05/24.
//

import SwiftUI
import SwiftData

@main
struct couple_telecathicApp: App {
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
        .modelContainer(for: [User.self])
        .environment(locationManager)
    }
}
