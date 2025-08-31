//
//  SaveTagRemoveApplicationUseCaseRequest.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ削除申請保存 UseCase リクエスト
struct SaveTagRemoveApplicationUseCaseRequest {
    /// タグ名
    let tagName: String
    
    /// ユーザーUID
    let userUid: String
    
    /// クリエイターID
    let creatorId: String
    
    init(tagName: String, userUid: String, creatorId: String) {
        self.tagName = tagName
        self.userUid = userUid
        self.creatorId = creatorId
    }
    
    /// リクエストのバリデーション
    func validate() throws {
        let trimmedTagName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTagName.isEmpty {
            throw SaveTagRemoveApplicationUseCaseError.invalidTagName
        }
        
        if userUid.isEmpty {
            throw SaveTagRemoveApplicationUseCaseError.invalidUserUid
        }
        
        if creatorId.isEmpty {
            throw SaveTagRemoveApplicationUseCaseError.invalidCreatorId
        }
    }
}