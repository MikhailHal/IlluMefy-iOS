//
//  SaveTagAddApplicationRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/31.
//

import Foundation

/// タグ追加申請保存リクエスト
struct SaveTagAddApplicationRequest: Codable {
    /// タグ名
    let name: String
    
    /// ユーザーUID
    let userUid: String
    
    /// 申請日時
    let createdAt: Date
    
    /// 審査状況
    let state: String
    
    init(name: String, userUid: String, createdAt: Date = Date(), state: String = "Not Processed") {
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.userUid = userUid
        self.createdAt = createdAt
        self.state = state
    }
}