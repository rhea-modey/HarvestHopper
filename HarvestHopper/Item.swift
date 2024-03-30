//
//  Item.swift
//  HarvestHopper
//
//  Created by Rhea Modey on 3/30/24.
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
