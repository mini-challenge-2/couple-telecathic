//
//  ProfileScreen.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 01/06/24.
//

import SwiftUI
import SwiftData

struct ProfileScreen: View {
    @State var username: String = "Pria Tampan dan Berani"
    @State var gender : String = "Male"
    @State var id: String = UserDefaults.standard.string(forKey: "userId") ?? "123"
    @State var birthdate: Date = Date()
    @Query var users: [User]
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var partner: Partner
    @State var showSheetConnect: Bool = false
    
    @State var myEmail: String = "Your Email"
    @State var myUsername: String = "Your Username"
    
    let genderOption = ["Male", "Female"]
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text("Profile")
                        .font(.system(size: 24, weight: .semibold))
                    Spacer()
                }.padding(.horizontal, 20)
                Spacer().frame(height: 8)
                HStack{
                    ProfileAvatar(username: "Bububku Cayangku", avatarPhoto: "Misellia")
                    
                    Spacer()
                    
                    Image("Heart")
                        .resizable()
                        .frame(maxWidth: 52, maxHeight: 53)
                    
                    Spacer()
                    
                    if partner.username != nil
                    {
                        ProfileAvatar(username: "Bububku Cayangku", avatarPhoto: "Misellia")
                    }else{
                        ProfileAvatar(username: "Unknown", avatarPhoto: "person")
                    }
                }.padding(.horizontal, 16)
                
                Form{
                    Section("Personal Data"){
                        HStack{
                            Text("Username")
                            Spacer()
                            Text(myUsername)
                                .lineLimit(1)
                                .multilineTextAlignment(.trailing)
                                .truncationMode(.tail)
                        }
                        HStack{
                            Text("Id")
                            Spacer()
                            TextField("Id", text: $id).multilineTextAlignment(.trailing).disabled(true)
                                .foregroundStyle(Color("GrayDisabled"))
                        }
                        HStack{
                            Text("Birthdate")
                            Spacer()
                            DatePicker(
                                "",
                                selection: $birthdate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .labelsHidden()
                        }
                        HStack{
                            Picker("Gender",
                                   selection: $gender) {
                                ForEach(genderOption, id: \.self) { gender in
                                    Text(gender)
                                }
                            }.pickerStyle(.navigationLink)
                        }
                    }
                    
                    Section("Account"){
                        HStack{
                            Text("My Account")
                            Spacer()
                            Text(myEmail)
                                .multilineTextAlignment(.trailing).disabled(true)
                                .foregroundStyle(Color("GrayDisabled"))
                        }
                        HStack{
                            Text("Partner's Account")
                            Spacer()
                            Text(partner.email ?? "Unknown")
                                .multilineTextAlignment(.trailing).disabled(true)
                                .foregroundStyle(Color("GrayDisabled"))
                        }
                    }
                    
                    Section{
                        if partner.username != nil{
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                                Text("Disconnect Partner")
                            }
                        }else{
                            Button(action: {
                                showSheetConnect.toggle()
                            }){
                                Text("Connect Partner")
                            }
                        }
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                            Text("Sign Out")
                        }
                    }
                }
                Spacer()
            }.background(Color("Surface"))
        }.task {
            myEmail = users.first?.email ?? "Your Email"
            myUsername = users.first?.username ?? "Your Username"
            id = UserDefaults.standard.string(forKey: "userId") ?? "123"
            getPartnerData()
        }
        .sheet(isPresented: $showSheetConnect){
            NavigationStack{
                VStack{
                    HStack{
                        Text("Your Id").font(.system(size: 17))
                        Spacer()
                    }
                    TextField("Your Partner's Id", text: .constant(id))
                        .textFieldStyle(.roundedBorder).disabled(true)
                    
                    HStack{
                        Text("Your Partner's Id").font(.system(size: 17))
                        Spacer()
                    }
                    TextField("Your Partner's Id", text: $partner.id)
                        .textFieldStyle(.roundedBorder)
                    Spacer()
                }.padding().toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            connectPartner()
                            showSheetConnect.toggle()
                        }
                    }
                }
            }
        }
    }
    
    func connectPartner(){
        let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/connect")!
        var request = URLRequest(url: url)
        let userId = UserDefaults.standard.string(forKey: "userId")
        let partnerId = partner.id
        let connectData = [
            "user_id": userId,
            "partner_id": partnerId]
        
        let data = try! JSONEncoder().encode(connectData)
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
                    let connectResponse = try JSONDecoder().decode(ConnectResponse.self, from: data)
                    print("Register Response: \(connectResponse)")
                    // Handle the decoded response as needed
                    print("userId : \(connectResponse.value.id)")
                    UserDefaults.standard.set(connectResponse.value.user_id, forKey: "userId")
                    UserDefaults.standard.set(connectResponse.value.partner_id, forKey: "partnerId")
                    getPartnerData()
                } catch {
                    print("Failed to decode JSON response: \(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func getPartnerData(){
        let userId = UserDefaults.standard.string(forKey: "userId") ?? ""
        
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
    }
    
    struct ProfileAvatar: View{
        @State var username: String = "unknown"
        @State var avatarPhoto: String = "person"
        
        var body: some View{
            VStack(alignment: .center){
                if(avatarPhoto == "person"){
                    Image(systemName: avatarPhoto)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 98, maxHeight: 98)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                }else{
                    Image(avatarPhoto)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: 98, maxHeight: 98)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/, style: /*@START_MENU_TOKEN@*/FillStyle()/*@END_MENU_TOKEN@*/)
                }
                
                Spacer().frame(maxHeight: 8)
                
                Text(username)
                    .frame(maxWidth: 130)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .font(.system(size: 14, weight: .medium))
            }
        }
    }
}

#Preview {
    ProfileScreen().environmentObject(Partner())
}
