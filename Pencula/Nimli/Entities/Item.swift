//
//  Item.swift
//  Nimli
//
//  Created by はると on 2025/02/09.
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
