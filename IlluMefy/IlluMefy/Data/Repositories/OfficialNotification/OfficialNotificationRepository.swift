//
//  OfficialNotificationRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation
import FirebaseRemoteConfig

/// 公式お知らせリポジトリ
final class OfficialNotificationRepository: OfficialNotificationRepositoryProtocol {
    let announcementKey = "announcement_content"
    let firebaseRemoteConfig: FirebaseRemoteConfigProtocol
    
    init(firebaseRemoteConfig: FirebaseRemoteConfigProtocol) {
        self.firebaseRemoteConfig = firebaseRemoteConfig
    }
    func fetchOfficialNotification() async throws -> OfficialNotification {
        let content = self.firebaseRemoteConfig.fetchValue(key: announcementKey) as String? ?? ""
        let notification = OfficialNotification(
            content: content,
        )
        return notification
    }
    
}
