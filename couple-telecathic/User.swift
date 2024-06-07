//
//  UserItem.swift
//  couple-telecathic
//
//  Created by Alfonso Kenji Prayogo on 05/06/24.
//

import Foundation
import SwiftData

@Model
final class User {
    var appleid: String
    var username: String
    var gender: Bool
    var email: String
    var birth_date: Date
    var latitude: Double
    var longitude: Double
    
    init(appleid: String, username: String, gender: Bool, email: String, birth_date: Date, latitude: Double, longitude: Double) {
        self.appleid = appleid
        self.username = username
        self.gender = gender
        self.email = email
        self.birth_date = birth_date
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct UserModel: Codable {
    var apple_id: String
    var username: String
    var sex: Int
    var email: String
    var birth: String
    var latitude: Double
    var longitude: Double
}
