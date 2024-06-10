//
//  MissYouMessageItem.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 30/05/24.
//

import SwiftUI

struct MissYouMessageItem: View {
    @Binding var messageItem: MessageItem
    var onclick: () -> Void
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(.white)
                .cornerRadius(7)
            
            HStack(alignment: .center){
                Image("\(messageItem.messageImage)").resizable().scaledToFit()
                VStack(alignment: .leading) {
                    Text("\(messageItem.messageTitle)")
                        .font(.system(size: 14, weight: .medium))
                    Spacer().frame(height: 4)
                    Text("\(messageItem.messageContent)")
                        .font(.system(size: 12, weight: .light))
                        .multilineTextAlignment(.leading)
                        .font(.subheadline)
                }.padding(.leading, 14)
                Spacer()
                
                Button(action: onclick){
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .center)){
                        Circle().fill(Color("Primary"))
                        Image(systemName: "paperplane").foregroundStyle(.white)
                    }
                }
            }.padding()
        }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/,maxHeight: 45)
    }
}

struct MessageItem {
    var messageImage: String
    var messageTitle: String
    var messageContent: String
    
    static let thinkingYouMessage = MessageItem(messageImage: "Heart", messageTitle: "Thinking about You ☺️", messageContent: "Hy Bub, I’m thinking about You right now")
    
    static let reminderEatMessage = MessageItem(messageImage: "LoveCupid", messageTitle: "Don’t forget to Eat 🍽️", messageContent: "Don’t let your stomach empty Babe<3")
    
    static let meetYouMessage = MessageItem(messageImage: "MissCupid", messageTitle: "Want to Meet You 🤗", messageContent: "I really miss you right now. Hope we can meet soon")
    
    static let rightBackMessage = MessageItem(messageImage: "Arrow", messageTitle: "Be Right Back 🥺", messageContent: "Babe, I will be unresponsive for a while. Gonna be right back ASAP")
    
    static func allTypes() -> [MessageItem] {
            return [.thinkingYouMessage, .reminderEatMessage, .meetYouMessage, .rightBackMessage]
        }
}

struct MessageListView: View {
    @State private var messages = MessageItem.allTypes()
    @EnvironmentObject var partner: Partner
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Miss You").font(.system(size: 34, weight: .bold))
                .padding(.top, 47)
            Text("Connect with your soulmate by sending a warm message").font(.system(size: 12, weight: .light))
            
                .padding(.bottom, 16)
                
            VStack(spacing: 16) {
                ForEach($messages, id: \.messageTitle) { $messageItem in
                    MissYouMessageItem(messageItem: $messageItem, onclick: {
                        sendMessage(message: messageItem)
                        print("Button was clicked for \(messageItem.messageTitle)!")
                    })
                    .padding(.vertical, 8)
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Miss You")
        .navigationBarHidden(true)
    }
    
    func getPartnerDeviceToken(){
        let userId = partner.id
        
        print("partner id: \(userId)")
        
        let url = URL(string: "https://inc-leonanie-ssabrut-63663dd3.koyeb.app/api/v1/register-device/\(userId)")!
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
                            print("trying to get partner's device token Raw JSON response: \(jsonString)")
                        }
                
                do {
                    let deviceTokenResponse = try JSONDecoder().decode(DeviceTokenResponse.self, from: data)
                            print("Device Token Response: \(deviceTokenResponse)")
                            // Handle the decoded response as needed

                    let partnerDevices = deviceTokenResponse.value
                    for device in partnerDevices{
                        if !partner.deviceToken.contains(device.token){
                            partner.deviceToken.append(device.token)
                        }
                    }
                } catch {
                    print("Failed to decode JSON response: \(error)")
                }
            }

            if statusCode == 200 {
                print("SUCCESS")
                print(data as Any)
            } else {
                print("FAILURE")
            }
        }

        task.resume()
    }
    
    func sendMessage(message: MessageItem){
        getPartnerDeviceToken()
        
        for token in partner.deviceToken{
            let url = URL(string: "http://127.0.0.1:8080/send-notification")!
            var request = URLRequest(url: url)
            
            let messageData = [
                "token" : token,
                "title": message.messageTitle,
                "body": message.messageContent]
            
            print(messageData)
            let data = try! JSONEncoder().encode(messageData)
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
    }
}

#Preview {
    NavigationView{
        MessageListView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("Surface"))
        
    }
}
