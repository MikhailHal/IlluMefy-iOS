//
//  GetOfficialNotificationUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 公式通知取得UseCaseのプロトコル
protocol GetOfficialNotificationUseCaseProtocol {
    /// サーバーから公式通知を取得
    func fetchOfficialNotification() async throws -> OfficialNotification?
}