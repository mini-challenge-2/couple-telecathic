//
//  TabView.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 01/06/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject var watchConnector = WatchConnector()
    @Environment(\.modelContext) private var modelContext
    
    init() {
           let tabBarAppearance = UITabBarAppearance()
           tabBarAppearance.configureWithOpaqueBackground()
           tabBarAppearance.backgroundColor = UIColor.white
           
           // Set the selected item color
           let primaryColor = UIColor(named: "Primary") ?? UIColor.systemBlue
           UITabBar.appearance().tintColor = primaryColor
           tabBarAppearance.stackedLayoutAppearance.selected.iconColor = primaryColor
           tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: primaryColor]

           UITabBar.appearance().standardAppearance = tabBarAppearance
           if #available(iOS 15.0, *) {
               UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
           }
        
            let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/register-device")!
            var request = URLRequest(url: url)
        
            let sharedDefaults = UserDefaults(suiteName: "group.liefransim.couple-telecathic")
            let deviceToken = sharedDefaults?.string(forKey: "deviceToken")
        
            let userId = UserDefaults.standard.string(forKey: "userId")
                
            let userData = ["user_id": userId, "token": deviceToken]
                print(userData)
                let data = try! JSONEncoder().encode(userData)
                print(data)
                request.httpBody = data
                request.setValue(
                    "application/json",
                    forHTTPHeaderField: "Content-Type"
                )
                request.httpMethod = "POST"
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print(response!)

                    if statusCode == 200 {
                        print("SUCCESS")
                    } else {
                        print("FAILURE")
                    }
                }

                task.resume()
       }
    
    var body: some View {
        TabView {
            NavigationStack{
                MessageListView()
                    .background(Color("Surface"))
            }
            .tabItem {
                Label("Miss You", systemImage: "envelope")
            }
            
            
            NavigationStack{
                SpecialDayScreen()
                    .environment(\.modelContext, modelContext)
                    .background(Color("Surface"))
                    .navigationTitle("Special Day")
                    .navigationBarTitleDisplayMode(.large)
            }
            .tabItem {
                Label("Special Day", systemImage: "heart")
            }
            
            NavigationStack{
                ObserveScreen()
                    .background(Color("Surface"))
            }
            .tabItem {
                Label("Observe", systemImage: "building")
            }
            
            NavigationStack{
                ProfileScreen()
                    .environment(\.modelContext, modelContext)
                
                    .background(Color("Surface"))
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainView()
}
