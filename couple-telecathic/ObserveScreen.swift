//
//  ObserveScreen.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 03/06/24.
//

import SwiftUI

struct ObserveScreen: View {
    
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text("Your Partner's Distance").foregroundStyle(.grayDisabled)
                    Text("12900 KM").font(.title).fontWeight(.bold)
                }
                Spacer()
            }.padding(20)
            HStack{
                VStack(alignment: .leading){
                    Text("📍 Bali, Indonesia").font(.largeTitle).fontWeight(.bold)
                    Text("Sunnny Cloudy").font(.title2).fontWeight(.semibold)
                    Text("13:00").font(.headline).foregroundStyle(.grayDisabled)
                }
                Spacer()
            }.padding(.horizontal, 20)
            
            Spacer()
            
            VStack(alignment: .center){
                Text("25°").font(.system(size: 76)).fontWeight(.bold)
                HStack{
                    Image("sunny-cloudy").resizable().frame(maxHeight: 48)
                }
            }
            Spacer()
        }.navigationTitle("Observe")
    }
}

#Preview {
    NavigationStack{
        ObserveScreen()
    }
}
