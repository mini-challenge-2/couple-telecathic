//
//  Theme.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 31/05/24.
//

import Foundation
import SwiftUI

extension Color {
    static let surfaceContainer = Color(hex: 0xE89E35)
    static let surfaceContainer2 = Color(hex: 0xFFF1B4)
    
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255.0,
            green: Double((hex >> 8) & 0xFF) / 255.0,
            blue: Double(hex & 0xFF) / 255.0,
            opacity: alpha
        )
    }
}
