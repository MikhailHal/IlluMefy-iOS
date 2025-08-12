//
//  FirebaseTimestamp.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//

import Foundation

/// Firebase Timestampの構造
struct FirebaseTimestamp: Codable {
    let _seconds: Int
    let _nanoseconds: Int
    
    /// DateオブジェクトへのConverter
    var toDate: Date {
        let timeInterval = TimeInterval(_seconds) + TimeInterval(_nanoseconds) / 1_000_000_000
        return Date(timeIntervalSince1970: timeInterval)
    }
}
