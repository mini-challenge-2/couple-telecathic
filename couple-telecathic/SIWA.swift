//
//  SIWA.swift
//  couple-telecathic
//
//  Created by Alfonso Kenji Prayogo on 30/05/24.
//

import AuthenticationServices
import SwiftUI

struct SIWA: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("email") var email: String = ""
    @AppStorage("firstName") var firstName: String = ""
    @AppStorage("lastName") var lastName: String = ""
    @AppStorage("userId") var userId: String = ""

    @State private var isSignedIn = false

    var body: some View {
        NavigationView {
            ZStack {
                Color.white // Set the background color to white
                    .edgesIgnoringSafeArea(.all) // Ensure it covers the entire screen

                VStack {
                    Text("Telecathic")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.pink)
                    
                    if userId.isEmpty {
                        SignInWithAppleButton(.continue) { request in
                            request.requestedScopes = [.email, .fullName]
                        } onCompletion: { result in
                            switch result {
                            case .success(let auth):
                                switch auth.credential {
                                case let credential as ASAuthorizationAppleIDCredential:
                                    // User ID
                                    let userId = credential.user
                                    // User info
                                    let email = credential.email
                                    let firstName = credential.fullName?.givenName
                                    let lastName = credential.fullName?.familyName
                                    
                                    self.email = email ?? ""
                                    self.userId = userId
                                    self.firstName = firstName ?? ""
                                    self.lastName = lastName ?? ""
                                    
                                    self.isSignedIn = true // Set isSignedIn to true
                                default:
                                    break
                                }
                            case .failure(let error):
                                print(error)
                            }
                        }
                        .signInWithAppleButtonStyle(.black)
                        .frame(height: 50)
                        .padding()
                        .cornerRadius(8)
                    } else {
                        NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true), isActive: $isSignedIn) {
                            EmptyView()
                        }
                        .hidden()
                    }
                    
                    Text("By signing in, you agree to our Terms of Service and Privacy Policy")
                        .foregroundColor(Color.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                .padding()
            }
        }
        .onAppear {
            if !userId.isEmpty {
                print("User ID: \(userId)") // Print the user ID if already signed in
                isSignedIn = true
            }
        }
    }
}

#Preview {
    SIWA()
}
