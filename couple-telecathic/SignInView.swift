//
//  SIWA.swift
//  couple-telecathic
//
//  Created by Alfonso Kenji Prayogo on 30/05/24.
//

import SwiftUI
import AuthenticationServices
import SwiftData

struct SignInView: View {
    @Query var users: [User] // Fetch users using SwiftData
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var partner: Partner

    @State private var user: User? // Stores signed-in user data (partially complete)
    @State private var showingProfileCompletion = false

    var body: some View {
        NavigationView {
            VStack{
                if let user = user {
                    if user.username.isEmpty {
                        ProfileCompletionView(user: $user).navigationTitle("Profile Completion")
                            .environment(\.modelContext, modelContext)
                    } else {
                        MainView()
                            .environment(\.modelContext, modelContext)
                    }
                } else {
                    Spacer()
                    Spacer()
                    Text("Clover").font(.system(size: 48, weight: .semibold)).foregroundStyle(Color("Primary"))
                    HStack(spacing: 0){
                        Text("Make you feel ").font(.system(size: 18)).foregroundStyle(Color("Primary"))
                        Text("Closer ").font(.system(size: 18, weight: .bold)).foregroundStyle(Color("Primary"))
                        Text("to your ").font(.system(size: 18)).foregroundStyle(Color("Primary"))
                        Text("Lover").font(.system(size: 18, weight: .bold)).foregroundStyle(Color("Primary"))
                    }
                    Spacer()
                    
                    SignInWithAppleButton(
                        onRequest: { request in
                            // Configure the request
                            request.requestedScopes = [.fullName, .email]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authResults):
                                self.handleSuccessfulSignIn(with: authResults)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    )
                    .frame(width: 280, height: 45)
                    .signInWithAppleButtonStyle(.black)
                    
                    Text("By sigining in, you agree to our Terms of Service and Privacy Policy").font(.system(size:12, weight: .light)).multilineTextAlignment(.center).foregroundStyle(Color("GrayDisabled")).padding()
                    Spacer()
                }
            }.onAppear {
                self.loadUserData()
            }.environment(\.modelContext, modelContext)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper behavior on all device sizes
    }

    @MainActor private func handleSuccessfulSignIn(with authResults: ASAuthorization) {
        guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential else { return }

        // Extract user information from credential (consider privacy options)
        let appleID = appleIDCredential.user
        let email = appleIDCredential.email ?? "" // Store only if essential

        // Check if the user already exists
        if let existingUser = users.first(where: { $0.appleid == appleID }) {
            user = existingUser
            getPartnerData()
            if existingUser.username.isEmpty {
                showingProfileCompletion = true
            }
        } else {
            if let userData = getUserData(appleId: appleID) {
                let dateFormatter = ISO8601DateFormatter()
                
                user = User(appleid: userData.apple_id, username: userData.username, gender: userData.sex == 1, email: userData.email, birth_date: dateFormatter.date(from: userData.birth) ?? Date(), latitude: userData.latitude, longitude: userData.longitude)
                
                saveUserData(User(appleid: userData.apple_id, username: userData.username, gender: userData.sex == 1, email: userData.email, birth_date: dateFormatter.date(from: userData.birth) ?? Date(), latitude: userData.latitude, longitude: userData.longitude))
            } else {
                let newUser = User(
                    appleid: appleID,
                    username: "",
                    gender: false,
                    email: email,
                    birth_date: Date(),
                    latitude: 0.0,
                    longitude: 0.0
                )
                saveUserData(newUser)
                user = newUser
            }
            
            getPartnerData()
             // Save partial user data
            showingProfileCompletion = true
        }
    }

    private func loadUserData() {
        // Load user data from SwiftData if available
        if let savedUser = users.first {
            user = savedUser
            print("getting user data from local")
            let userValue = getUserData(appleId: savedUser.appleid)
        }
    }
    
    private func getUserData(appleId : String) -> UserValue?{
        let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/user/\(appleId)")!
        var request = URLRequest(url: url)
        
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpMethod = "GET"
        
        var userData: UserValue? = nil
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let statusCode = (response as! HTTPURLResponse).statusCode
            print(response!)
            
            if let data = data{
                if let jsonString = String(data: data, encoding: .utf8) {
                            print("trying to get user Data Raw JSON response: \(jsonString)")
                        }
                
                do {
                    let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                            print("Register Response: \(registerResponse)")
                            // Handle the decoded response as needed
                        print("userId : \(registerResponse.value.id)")
                    
                    UserDefaults.standard.set(registerResponse.value.id, forKey: "userId")
                    UserDefaults.standard.set(registerResponse.value.apple_id, forKey: "userAppleID")
                    
                    let sharedDefaults = UserDefaults(suiteName: "group.liefransim.couple-telecathic")
                    sharedDefaults?.set(registerResponse.value.id, forKey: "userId")
                    
                    let dateFormatter = ISO8601DateFormatter()
                    
                    let userLocal = User(appleid: registerResponse.value.apple_id, username: registerResponse.value.username, gender: registerResponse.value.sex == 1, email: registerResponse.value.email, birth_date: dateFormatter.date(from: registerResponse.value.birth) ?? Date(), latitude: registerResponse.value.latitude, longitude: registerResponse.value.longitude)
                    
                    saveUserData(userLocal)
                    userData = registerResponse.value
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
        
        return userData
    }
    
    func getPartnerData(){
        if let userId = UserDefaults.standard.string(forKey: "userId"){
            let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/couple-data/\(userId)")!
            var request = URLRequest(url: url)
            
            request.setValue(
                "application/json",
                forHTTPHeaderField: "Content-Type"
            )
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
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
                        
                        let sharedDefaults = UserDefaults(suiteName: "group.liefransim.couple-telecathic")
                        sharedDefaults?.set(registerResponse.value.id, forKey: "userId")
                        
                        let dateFormatter = ISO8601DateFormatter()
                        
                        partner.savePartnerData(id: registerResponse.value.id,appleid: registerResponse.value.apple_id, username: registerResponse.value.username, gender: registerResponse.value.sex == 1, email: registerResponse.value.email, birth_date: dateFormatter.date(from: registerResponse.value.birth) ?? Date(), latitude: registerResponse.value.latitude, longitude: registerResponse.value.longitude)
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
            print("the user doesn't have  partner")
        }
    }
    
    private func saveUserData(_ user: User) {
        modelContext.insert(user)
        
        do{
            try modelContext.save()
        }catch{
            print("can't save user data into local")
        }
        
        UserDefaults.standard.set(user.appleid, forKey: "userAppleID")
        
        print("saving user data into local : \(user)")
    }
}

struct ProfileCompletionView: View {
    @Binding var user: User?
    @Environment(\.modelContext) private var modelContext

    @State private var username = ""
    @State private var gender = false // Boolean for male/female
    @State private var birthDate = Date()

    var body: some View {
        ScrollView {
            Image("LoveCupid")
            HStack{
                Text("Username").font(.system(size: 17))
                Spacer()
            }
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            HStack{
                Text("Gender").font(.system(size: 17))
                Picker("Gender", selection: $gender) {
                    Text("Male").tag(false)
                    Text("Female").tag(true)
                }
                Spacer()
            }
            HStack{
                Text("Birth Date").font(.system(size: 17))
                Spacer()
            }
            DatePicker(
                            "",
                            selection: $birthDate,
                            in: Calendar.current.date(byAdding: .year, value: -100, to: Date())!...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(WheelDatePickerStyle())
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    user?.username = username
                    user?.gender = gender
                    user?.birth_date = birthDate
                    if let user = user {
                        saveUserData(user)
                        // Navigate to main view after completion or perform any action after saving
                    }
                }
            }
        }
        .onAppear {
            // Pre-fill with existing user data if available
            if let existingUser = user {
                username = existingUser.username
                gender = existingUser.gender
                birthDate = existingUser.birth_date
            }
        }
    }

    @MainActor
    private func saveUserData(_ user: User) {
        // Insert the user into the model context
        modelContext.insert(user)
        do {
            try modelContext.save() // Save the context
            let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/register")!
            var request = URLRequest(url: url)
            
            let userData = UserModel(apple_id: user.appleid, username: user.username, sex: user.gender ? 0 : 1, email: "09uij@gmail.com", birth: "2002-04-17", latitude: 1, longitude: 1)
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
                        let sharedDefaults = UserDefaults(suiteName: "group.liefransim.couple-telecathic")
                        sharedDefaults?.set(registerResponse.value.id, forKey: "userId")
                            } catch {
                                print("Failed to decode JSON response: \(error)")
                            }
                }
            }

            task.resume()
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    NavigationStack{
        ProfileCompletionView(user: .constant(User(appleid: "Liefran123@gmail.com", username: "Liefran", gender: true, email: "Liefran123@gmail.com", birth_date: Date(), latitude: 1, longitude: 1))).navigationTitle("Profile Completion")
    }
//    SignInView()
//        .modelContainer(for: [User.self])
}
