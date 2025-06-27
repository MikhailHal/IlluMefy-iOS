//
//  OperatorMessage.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 運営メッセージの情報
struct OperatorMessage: Equatable {
    let title: String
    let content: String
    let updatedAt: Date
    let isNew: Bool
    
    /// 更新日を表示用にフォーマット
    var formattedUpdatedAt: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: updatedAt)
    }
}