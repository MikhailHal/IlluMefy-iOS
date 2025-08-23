//
//  OfficialNotificationRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 公式お知らせリポジトリ
final class OfficialNotificationRepository: OfficialNotificationRepositoryProtocol {
    private var cachedNotification: OfficialNotification?
    
    func fetchOfficialNotification() async throws -> OfficialNotification? {
        // TODO: Remote Configから取得
        let notification = OfficialNotification(
            title: "お知らせ",
            content: "",
            updatedAt: Date(),
            isNew: false
        )
        cachedNotification = notification
        return notification
    }
    
    func getCachedOfficialNotification() -> OfficialNotification? {
        return cachedNotification
    }
}
