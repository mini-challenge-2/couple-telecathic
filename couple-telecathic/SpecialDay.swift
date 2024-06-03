//
//  SpecialDay.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 01/06/24.
//

import SwiftUI

struct SpecialDayItemComponent: View {
    @Binding var specialDayItem: SpecialDayItem
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .center)){
            Rectangle().fill(specialDayItem.color).cornerRadius(8)
            
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text(specialDayItem.type == SpecialDayType.counting.rawValue ? "It's been" : "There are").font(.system(size: 11))
                    Text("\(specialDayItem.days) days").font(.system(size: 32))
                    HStack(alignment: .bottom){
                        Text(specialDayItem.type == SpecialDayType.counting.rawValue ? "since our" : "to our").font(.system(size: 16))
                        Text(specialDayItem.label).font(.system(size: 16, weight: .bold))
                    }
                }
                Spacer()
                Image(specialDayItem.image).resizable().scaledToFit()
            }.frame(maxWidth: .infinity).padding(.vertical,16).padding(.horizontal, 23)
        }.frame(maxWidth: .infinity,maxHeight: 106).padding(.horizontal, 21)
    }
}

struct SpecialDayItem{
    var days: Int
    var label: String
    var type: String
    var color: Color
    var image: String
}

enum SpecialDayType: String, CaseIterable{
    case countdown = "Count Down"
    case counting = "Counting"
}

struct SpecialDayScreen: View{
    @State var specialDayItem: [SpecialDayItem] = [
        SpecialDayItem(days: 3006, label: "First Day", type: SpecialDayType.counting.rawValue, color: Color("PastelPink"), image: "LoveCupid"),
        SpecialDayItem(days: 33, label: "Anniversary", type: SpecialDayType.counting.rawValue, color: Color("PastelYellow"), image: "MissCupid"),
        SpecialDayItem(days: 301, label: "First Date", type: SpecialDayType.counting.rawValue, color: Color("PastelBlue"), image: "Arrow"),
    ]
    
    @State var addModalPresented = false
    @State var newSpecialDayLabel = ""
    @State var newSpecialDayDate: Date = Date()
    @State var newSpecialDayType: String = SpecialDayType.countdown.rawValue
    @State var newSpecialDayColor: Color = Color("PastelYellow")
    @State var newSpecialDayImage: String = "Heart"
    @State var isTitleValid: Bool = true
    @State var showConfirmationDialog: Bool = false
    @State var allowDismiss: Bool = false
    
    let colorOption = [Color("PastelYellow"),
                       Color("PastelBlue"),
                       Color("PastelGreen"),
                       Color("PastelOrange"),
                       Color("PastelPink"),
                       Color("PastelPurple")]
    let imageOption = ["Heart", "LoveCupid", "MissCupid", "Arrow"]
    let specialDayTypeOption : [String] = SpecialDayType.allCases.map{ $0.rawValue }
    
    @State var dateRange: ClosedRange<Date> = Date()...Calendar.current.date(byAdding: .year, value: 20, to: Date())!

    var body: some View{
        VStack{
            HStack{
                Spacer()
                Button(action: {
                    addModalPresented.toggle()
                }){
                    ZStack(alignment: Alignment(horizontal: .center, vertical: .center)){
                        HStack{
                            Text("+ Add").foregroundStyle(.white).font(.system(size: 16, weight: .semibold))
                        }.padding(.vertical, 4).padding(.horizontal, 8)
                    }.background(Color("Primary")).cornerRadius(5)
                }
            }.frame(maxWidth: .infinity).padding(.horizontal, 23)
            ScrollView{
                VStack{
                    ForEach($specialDayItem, id: \..label) { $specialDayItem in
                        SpecialDayItemComponent(specialDayItem: $specialDayItem)
                        .padding(.vertical, 8)
                    }
                }
            }
            Spacer()
        }.navigationTitle("Special Days").navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $addModalPresented,  onDismiss: {
                if !allowDismiss && !newSpecialDayLabel.isEmpty {
                    showConfirmationDialog = true
                }
            }){
                NavigationStack{
                    VStack{
                        HStack{
                            Text("Day's Title").font(.system(size: 17))
                            Spacer()
                        }
                        TextField("Day's Title", text: $newSpecialDayLabel)
                            .textFieldStyle(.roundedBorder)
                        
                        if !isTitleValid {
                            HStack{
                                Text("Day's Title is required").foregroundColor(.red).font(.system(size: 12))
                                Spacer()
                            }
                        }
                        
                        HStack{
                            Text("Type").font(.system(size: 17))
                            Spacer()
                        }
                        HStack{
                            Picker("Type",
                                      selection: $newSpecialDayType) {
                                      ForEach(specialDayTypeOption, id: \.self) { type in
                                         Text(type)
                                       }
                            }
                            .onChange(of: newSpecialDayType) {
                                    updateDateRange()
                                }
                        }
                        
                        HStack{
                            Text("Date").font(.system(size: 17))
                            Spacer()
                        }
                        DatePicker(
                                        "",
                                        selection: $newSpecialDayDate,
                                        in: dateRange,
                                        displayedComponents: .date
                                    )
                                    .datePickerStyle(WheelDatePickerStyle())
                                    .labelsHidden()
                        HStack {
                           Text("Color").font(.system(size: 17))
                           Spacer()
                       }
                        
                       HStack {
                           ForEach(colorOption, id: \.self) { color in
                               ColorOption(color: color, selectedColor: $newSpecialDayColor)
                           }
                           Spacer()
                       }
                        
                        HStack {
                           Text("Icon").font(.system(size: 17))
                           Spacer()
                       }
                        
                       HStack {
                           ForEach(imageOption, id: \.self) { image in
                               ImageOption(image: image, selectedImage: $newSpecialDayImage)
                           }
                           Spacer()
                       }
                        
                        Spacer()
                    }.padding()
                    .navigationTitle("Add Special Day")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                if newSpecialDayLabel.isEmpty {
                                    allowDismiss = true
                                    addModalPresented = false
                                } else {
                                    showConfirmationDialog = true
                                }
                            }
                            .alert(isPresented: $showConfirmationDialog) {
                                Alert(
                                    title: Text("Unsaved Changes"),
                                    message: Text("You have unsaved changes. Are you sure you want to cancel?"),
                                    primaryButton: .destructive(Text("Discard Changes")) {
                                        reset()
                                        allowDismiss = true
                                        addModalPresented = false
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }

                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                if newSpecialDayLabel.isEmpty {
                                    isTitleValid = false
                                } else {
                                    isTitleValid = true
                                    let daysDifference = calculateDaysDifference(from: newSpecialDayDate, type: newSpecialDayType)
                                    specialDayItem.append(SpecialDayItem(
                                        days: daysDifference,
                                        label: newSpecialDayLabel,
                                        type: newSpecialDayType,
                                        color: newSpecialDayColor,
                                        image: "LoveCupid"
                                    ))
                                    reset()
                                    addModalPresented.toggle()
                                }
                            }
                        }
                    }.onDisappear {
                        if !allowDismiss && !newSpecialDayLabel.isEmpty {
                            showConfirmationDialog = true
                        }
                    }
                }
            }
    }
    
    func calculateDaysDifference(from date: Date, type: String) -> Int {
            let calendar = Calendar.current
            let currentDate = Date()
            
            if type == SpecialDayType.countdown.rawValue {
                return calendar.dateComponents([.day], from: currentDate, to: date).day ?? 0
            } else {
                return calendar.dateComponents([.day], from: date, to: currentDate).day ?? 0
            }
        }
    
    func reset(){
        newSpecialDayDate = Date()
        newSpecialDayType = SpecialDayType.countdown.rawValue
        newSpecialDayLabel = ""
    }
    
    func updateDateRange(){
        let calendar = Calendar.current
        let today = Date()
        if newSpecialDayType == SpecialDayType.countdown.rawValue {
                dateRange = today...calendar.date(byAdding: .year, value: 20, to: today)!
            } else {
                dateRange = calendar.date(byAdding: .year, value: -20, to: today)!...today
            }
    }
}

struct ColorOption: View{
    let color: Color
    @Binding var selectedColor : Color
    
    var body: some View{
        Button(action: {
            selectedColor = color
        }){
            ZStack{
                Rectangle().fill(color).cornerRadius(12).frame(maxWidth: 48, maxHeight: 48).overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(selectedColor == color ? Color("Primary") : .gray, lineWidth: 2)
                )
            }
        }
    }
}

struct ImageOption: View{
    let image: String
    @Binding var selectedImage : String
    
    var body: some View{
        Button(action: {
            selectedImage = image
        }){
            ZStack{
                Image(image).resizable().frame(maxWidth: 52, maxHeight: 53)
            }.cornerRadius(12).padding(12)
                .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedImage == image ? Color("Primary") : .gray, lineWidth: 2)
            )
        }
    }
}

#Preview {
    NavigationView{
        SpecialDayScreen()
    }
}
