//
//  Partner.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 09/06/24.
//

import Foundation

class Partner: ObservableObject {
    @Published var id: String
    @Published var appleid: String?
    @Published var username: String?
    @Published var gender: Bool?
    @Published var email: String?
    @Published var birth_date: Date?
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var deviceToken: [String]
    
    init(id: String? = nil, appleid: String? = nil, username: String? = nil, gender: Bool? = nil, email: String? = nil, birth_date: Date? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.id = id ?? ""
        self.appleid = appleid
        self.username = username
        self.gender = gender
        self.email = email
        self.birth_date = birth_date
        self.latitude = latitude
        self.longitude = longitude
        self.deviceToken = []
    }
    
    func savePartnerData(id: String? = nil, appleid: String? = nil, username: String? = nil, gender: Bool? = nil, email: String? = nil, birth_date: Date? = nil, latitude: Double? = nil, longitude: Double? = nil){
        self.id = id ?? ""
        self.appleid = appleid
        self.username = username
        self.gender = gender
        self.email = email
        self.birth_date = birth_date
        self.latitude = latitude
        self.longitude = longitude
    }
}
