//
//  ProfileScreen.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 01/06/24.
//

import SwiftUI

struct ProfileScreen: View {
    @State var username: String = "Pria Tampan dan Berani"
    @State var gender : String = "Male"
    @State var id: String = "12345678"
    @State var birthdate: Date = Date()
    @State var myAccount: String = "TampanAndBrave@gmail.com"
    @State var partnerAccount: String = "BububCygz@gmail.com"
    
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
                    
                    ProfileAvatar(username: "Bububku Cayangku", avatarPhoto: "Misellia")
                }.padding(.horizontal, 16)
                
                Form{
                    Section("Personal Data"){
                        HStack{
                            Text("Username")
                            Spacer()
                            TextField("Username", text: $username).frame(maxWidth: 180).lineLimit(1)
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
                            TextField("My Account", text: $myAccount).multilineTextAlignment(.trailing).disabled(true)
                                .foregroundStyle(Color("GrayDisabled"))
                        }
                        HStack{
                            Text("Partner's Account")
                            Spacer()
                            TextField("Partner's Account", text: $partnerAccount).multilineTextAlignment(.trailing).disabled(true)
                                .foregroundStyle(Color("GrayDisabled"))
                        }
                    }
                    
                    Section{
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                            Text("Disconnect Partner")
                        }
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
                            Text("Sign Out")
                        }
                    }
                }
                Spacer()
            }.background(Color("Surface"))
        }
    }
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

#Preview {
    ProfileScreen()
}
