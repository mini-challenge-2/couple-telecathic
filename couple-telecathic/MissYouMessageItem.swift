//
//  MissYouMessageItem.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 30/05/24.
//

import SwiftUI

struct MissYouMessageItem: View {
    var body: some View {
        ZStack{
            Rectangle()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 65)
                .background(.white)
                .cornerRadius(7)
                .padding(18)
        }
    }
}

struct MessageItem {
    var messageTitle: String
    var messageContent: String
}

#Preview {
    MissYouMessageItem()
}
