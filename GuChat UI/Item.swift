//
//  Item.swift
//  GuChat UI
//
//  Created by Nick Shah on 5/6/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
