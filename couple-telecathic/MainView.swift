//
//  TabView.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 01/06/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
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
