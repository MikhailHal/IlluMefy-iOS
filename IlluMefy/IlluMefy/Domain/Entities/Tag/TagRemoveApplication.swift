//
//  TagRemoveApplication.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ削除申請の時のドメインモデル
struct TagRemoveApplication {
    /** タグ名*/
    let name: String
    /** ユーザーuid*/
    let userUid: String
    /** クリエイターid */
    let creatorId: String
    /** 申請日時*/
    let createdAt: Date
    /** 審査状況*/
    let state = "Not Processed"
}