//
//  SaveTagRemoveApplicationRequest.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ削除申請保存リクエスト
struct SaveTagRemoveApplicationRequest: Codable {
    /// タグ名
    let name: String
    
    /// ユーザーUID
    let userUid: String
    
    /// クリエイターID
    let creatorId: String
    
    /// 申請日時
    let createdAt: Date
    
    /// 審査状況
    let state: String
    
    init(name: String, userUid: String, creatorId: String, createdAt: Date = Date(), state: String = "Not Processed") {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.userUid = userUid
        self.creatorId = creatorId
        self.createdAt = createdAt
        self.state = state
    }
}