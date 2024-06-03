//
//  SpecialDayItem.swift
//  couple-telecathic
//
//  Created by Liefran Satrio Sim on 03/06/24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class SpecialDay {
    var date: Date
    var label: String
    var type: String
    var color: String
    var image: String

    init(date: Date = Date(), label: String = "", type: String = "", color: String = "", image: String) {
        self.date = date
        self.label = label
        self.type = type
        self.color = color
        self.image = image
    }
}
