//
//  MyProfile.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 08/06/24.
//

import Foundation
import SwiftData
import SwiftUI

class MyProfile: ObservableObject{
    @Query var users: [User]
    @Published var myAppleId: String?
    @Published var myId: String?
    @Published var myData: User?
    @Published var myCoupleData: User?
    @Published var modelContext: ModelContext
    
    init(myData: User? = nil, myCoupleData: User? = nil, modelContext: ModelContext, myAppleId: String? = nil, myId: String? = nil) {
        self.modelContext = modelContext
        self.myData = myData
        self.myCoupleData = myCoupleData
        self.myAppleId = myAppleId
        self.myId = myId
    }
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchMyData()
        fetchMyCoupleData()
    }
    
    func registerNewUser(appleID: String, email: String){
        let newUser = User(
            appleid: appleID,
            username: "",
            gender: false,
            email: email,
            birth_date: Date(),
            latitude: 0.0,
            longitude: 0.0
        )
        
        modelContext.insert(newUser)
        
        print("user in swift data : \(users)")
        
        do {
            try modelContext.save()
        } catch {
            print("Error updating user data: \(error)")
        }
    }
    
    func saveUserData(user: User){
        modelContext.insert(user)
        
        print("user in swift data : \(users)")
        
        do {
            try modelContext.save()
        } catch {
            print("Error updating user data: \(error)")
        }
    }
        
    func fetchMyData() {
        if users.isEmpty{
            print("user is not detected in Local")
            let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/user/\(myAppleId ?? "")")!
            var request = URLRequest(url: url)
            
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                print("getting user data from remote")
                let statusCode = (response as! HTTPURLResponse).statusCode
                print(response!)
                
                if let data = data{
                    if let jsonString = String(data: data, encoding: .utf8) {
                                print("Raw JSON response: \(jsonString)")
                            }
                    
                    do {
                        let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                                print("Register Response: \(registerResponse)")
                                // Handle the decoded response as needed
                            print("userId : \(registerResponse.value.id)")
                        
                        UserDefaults.standard.set(registerResponse.value.id, forKey: "userId")
                        UserDefaults.standard.set(registerResponse.value.apple_id, forKey: "userAppleID")
                        
                        let dateFormatter = ISO8601DateFormatter()
                        
                        let userLocal = User(appleid: registerResponse.value.apple_id, username: registerResponse.value.username, gender: registerResponse.value.sex == 1, email: registerResponse.value.email, birth_date: dateFormatter.date(from: registerResponse.value.birth) ?? Date(), latitude: registerResponse.value.latitude, longitude: registerResponse.value.longitude)
                        
                        self.updateMyData(userLocal)
                        self.myId = registerResponse.value.id
                        print("user data id: \(self.myId ?? "unknown")")
                    } catch {
                        print("Failed to decode JSON response: \(error)")
                    }
                }

                if statusCode == 200 {
                    print("SUCCESS")
                } else {
                    print("FAILURE")
                }
            }

            task.resume()
        }else{
            print("user is detected in Local")
            self.myData = users.first
        }
    }
    
    func fetchMyCoupleData() {
//        let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/user/\(appleId)")!
//        var request = URLRequest(url: url)
//        
//        request.setValue(
//            "application/json",
//            forHTTPHeaderField: "Content-Type"
//        )
//        request.httpMethod = "GET"
//        
//        var userData: UserValue? = nil
//        
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            let statusCode = (response as! HTTPURLResponse).statusCode
//            print(response!)
//            
//            if let data = data{
//                if let jsonString = String(data: data, encoding: .utf8) {
//                            print("Raw JSON response: \(jsonString)")
//                        }
//                
//                do {
//                    let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
//                            print("Register Response: \(registerResponse)")
//                            // Handle the decoded response as needed
//                        print("userId : \(registerResponse.value.id)")
//                    
//                    UserDefaults.standard.set(registerResponse.value.id, forKey: "userId")
//                    UserDefaults.standard.set(registerResponse.value.apple_id, forKey: "userAppleID")
//                    
//                    let dateFormatter = ISO8601DateFormatter()
//                    
//                    let userLocal = User(appleid: registerResponse.value.apple_id, username: registerResponse.value.username, gender: registerResponse.value.sex == 1, email: registerResponse.value.email, birth_date: dateFormatter.date(from: registerResponse.value.birth) ?? Date(), latitude: registerResponse.value.latitude, longitude: registerResponse.value.longitude)
//                    
//                    saveUserData(userLocal)
//                    userData = registerResponse.value
//                } catch {
//                    print("Failed to decode JSON response: \(error)")
//                }
//            }
//
//            if statusCode == 200 {
//                print("SUCCESS")
//            } else {
//                print("FAILURE")
//            }
//        }
//
//        task.resume()
    }
    
    func updateMyData(_ newData: User) {
        print("trying to add data into swiftData")
        myData = newData
        do {
            try modelContext.save()
        } catch {
            print("Error updating user data: \(error)")
        }
    }
    
    func updateMyCoupleData(_ newCoupleData: User) {
        myCoupleData = newCoupleData
        do {
            try modelContext.save()
        } catch {
            print("Error updating user data: \(error)")
        }
    }
}
