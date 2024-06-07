//
//  ContentView.swift
//  couple-telecathic-watch Watch App
//
//  Created by Liefran Satrio Sim on 04/06/24.
//

import SwiftUI

struct ContentView: View {
    @State private var messages = MessageItem.allTypes()
    @StateObject var iosConnector = IOSConnector()
    
    var body: some View {
        NavigationStack{
            ScrollView{
                ForEach($messages, id: \.messageTitle) { $messageItem in
                    MessageComponent(messageItem: $messageItem, onClick: {
                        
                    })
                    .padding(.vertical, 2)
                }
            }.navigationTitle("Miss you button")
                .navigationBarTitleDisplayMode(.inline)
        }.ignoresSafeArea()
    }
}

struct MessageComponent: View{
    @Binding var messageItem: MessageItem
    @StateObject var iosConnector = IOSConnector()
    var onClick: () -> Void
    
    var body: some View{
        NavigationLink(destination: DetailView(messageItem: $messageItem, sendData: {
            iosConnector.sendMessageToIOS()
        })){
            ZStack{
                HStack{
                    Image(messageItem.messageImage).resizable().frame(maxWidth: 28, maxHeight: 28).scaledToFit()
                    Spacer().frame(maxWidth: 8)
                    Text(messageItem.messageTitle).font(.system(size: 11, weight: .medium))
                    Spacer()
                }
            }.frame(maxHeight: 50).padding(.horizontal, 4)
        }
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

struct DetailView: View{
    @Binding var messageItem: MessageItem
    var sendData: () -> Void
    
    var body: some View{
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 9).fill(Color("Container"))
                
                VStack{
                    HStack{
                        Image(messageItem.messageImage).resizable().frame(maxWidth: 28, maxHeight: 28).scaledToFit()
                        Spacer().frame(maxWidth: 8)
                        Text(messageItem.messageTitle).font(.system(size: 12, weight: .medium))
                    }
                    Spacer()
                    Text(messageItem.messageContent).font(.system(size: 12, weight: .regular))
                    Spacer()
                }.padding(12)
            }
            Spacer().frame(maxHeight: 8)
            Button(action: sendData){
                Text("Send").font(.system(size: 24, weight: .medium)).foregroundStyle(.white)
            }.background(Color("Primary"))
                .mask(RoundedRectangle(cornerRadius: 24))
        }
    }
}

#Preview {
    ContentView()
}
