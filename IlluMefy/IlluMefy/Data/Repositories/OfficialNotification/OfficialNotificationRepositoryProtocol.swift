//
//  OperatorMessageRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 運営メッセージリポジトリのプロトコル
protocol OfficialNotificationRepositoryProtocol {
    /// お知らせ取得
    func getOfficialNotification() -> String
}
