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

    @State private var user: User? // Stores signed-in user data (partially complete)
    @State private var showingProfileCompletion = false

    var body: some View {
        NavigationView {
            VStack {
                if let user = user {
                    // Display partial user info (avoid sensitive data)
                    Text("Username is: \(user.username)")
                        .font(.title)
                        .foregroundStyle(.white)
                    if user.username.isEmpty {
                        NavigationLink(destination: ProfileCompletionView(user: $user), isActive: $showingProfileCompletion) {
                            EmptyView()
                        }
                        .hidden()
                    } else {
                        Text("Welcome, \(user.username)!")
                    }
                } else {
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
                    .signInWithAppleButtonStyle(.white)
                }
            }
            .onAppear {
                self.loadUserData()
            }
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
            if existingUser.username.isEmpty {
                showingProfileCompletion = true
            }
        } else {
            // Create a new user with the provided details and navigate to profile completion
            let newUser = User(appleid: appleID, username: "", gender: false, email: email, birth_date: Date(), latitude: 0.0, longitude: 0.0)
            user = newUser
            saveUserData(newUser) // Save partial user data
            showingProfileCompletion = true
        }
    }

    private func loadUserData() {
        // Load user data from SwiftData if available
        if let savedUser = users.first {
            user = savedUser
        }
    }

    private func saveUserData(_ user: User) {
        modelContext.insert(user)
        do {
            try modelContext.save() // Save the context
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }
}

struct ProfileCompletionView: View {
    @Binding var user: User?
    @Environment(\.modelContext) private var modelContext

    @State private var username = ""
    @State private var gender = false // Boolean for male/female
    @State private var birthDate = Date()

    var body: some View {
        VStack {
            TextField("Username", text: $username)
            Picker("Gender", selection: $gender) {
                Text("Male").tag(false)
                Text("Female").tag(true)
            }
            DatePicker("Birth Date", selection: $birthDate)
            Button("Save Profile") {
                user?.username = username
                user?.gender = gender
                user?.birth_date = birthDate
                if let user = user {
                    saveUserData(user)
                    // Navigate to main view after completion or perform any action after saving
                }
            }
        }
        .padding()
        .navigationTitle("Complete Profile")
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
            
            let userData = UserModel(apple_id: user.appleid, username: user.username, sex: user.gender ? 0 : 1, email: user.email, birth: DateFormatter().string(from: user.birth_date), latitude: 1, longitude: 1)
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
        } catch {
            print("Failed to save user data: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SignInView()
        .modelContainer(for: [User.self])
}
