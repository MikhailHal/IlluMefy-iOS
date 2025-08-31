//
//  TagAddApplication.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/31.
//


import Foundation

/// タグ追加申請の時のドメインモデル
struct TagAddApplication {
    /** タグ名*/
    let name: String
    /** ユーザーuid*/
    let userUid: String
    /** 申請日時*/
    let createdAt: Date
    /** 審査状況*/
    let state = "Not Processed"
}
