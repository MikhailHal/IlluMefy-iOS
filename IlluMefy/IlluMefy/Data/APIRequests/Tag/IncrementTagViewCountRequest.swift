//
//  IncrementTagViewCountRequest.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ閲覧数増加リクエスト
struct IncrementTagViewCountRequest: Codable {
    /// タグID
    let tagId: String
    
    /// インクリメント日時
    let incrementedAt: Date
    
    init(tagId: String, incrementedAt: Date = Date()) {
        self.tagId = tagId
        self.incrementedAt = incrementedAt
    }
}