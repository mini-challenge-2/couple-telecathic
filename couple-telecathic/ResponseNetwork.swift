//
//  ResponseNetwork.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 08/06/24.
//

import Foundation

struct RegisterResponse: Codable {
    let status: Int
    let message: String
    let value: UserValue
}

struct ConnectResponse: Codable {
    let status: Int
    let message: String
    let value: ConnectValue
}

struct ConnectValue: Codable {
    let id: Int
    let user_id: String
    let partner_id: String
}

struct DeviceTokenResponse: Codable {
    let status: Int
    let message: String
    let value: [DeviceTokenValue]
}

struct DeviceTokenValue: Codable {
    let id: Int
    let user_id: String
    let token: String
}

struct UserValue: Codable {
    let sex: Int
    let id: String
    let birth: String
    let longitude: Double
    let username: String
    let email: String
    let apple_id: String
    let latitude: Double
    let created_at: String
}
