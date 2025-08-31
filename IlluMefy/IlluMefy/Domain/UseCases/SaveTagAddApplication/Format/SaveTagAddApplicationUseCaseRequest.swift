//
//  SaveTagAddApplicationUseCaseRequest.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ追加申請保存 UseCase リクエスト
struct SaveTagAddApplicationUseCaseRequest {
    /// タグ名
    let tagName: String
    
    /// ユーザーUID
    let userUid: String
    
    init(tagName: String, userUid: String) {
        self.tagName = tagName
        self.userUid = userUid
    }
    
    /// リクエストのバリデーション
    func validate() throws {
        let trimmedTagName = tagName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedTagName.isEmpty {
            throw SaveTagAddApplicationUseCaseError.invalidTagName
        }
        
        if userUid.isEmpty {
            throw SaveTagAddApplicationUseCaseError.invalidUserUid
        }
    }
}