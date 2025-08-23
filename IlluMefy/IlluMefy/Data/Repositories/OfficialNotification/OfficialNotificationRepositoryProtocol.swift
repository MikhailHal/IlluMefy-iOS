//
//  OfficialNotificationRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 公式お知らせリポジトリのプロトコル
protocol OfficialNotificationRepositoryProtocol {
    /// サーバーから公式通知を取得
    func fetchOfficialNotification() async throws -> OfficialNotification?
    
    /// キャッシュされた公式通知を取得
    func getCachedOfficialNotification() -> OfficialNotification?
}
