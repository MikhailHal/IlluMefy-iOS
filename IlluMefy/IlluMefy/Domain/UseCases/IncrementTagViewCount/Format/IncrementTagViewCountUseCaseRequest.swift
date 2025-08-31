//
//  IncrementTagViewCountUseCaseRequest.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ閲覧数増加 UseCase リクエスト
struct IncrementTagViewCountUseCaseRequest {
    /// タグID
    let tagId: String
    
    init(tagId: String) {
        self.tagId = tagId
    }
    
    /// リクエストのバリデーション
    func validate() throws {
        if tagId.isEmpty {
            throw IncrementTagViewCountUseCaseError.invalidTagId
        }
    }
}