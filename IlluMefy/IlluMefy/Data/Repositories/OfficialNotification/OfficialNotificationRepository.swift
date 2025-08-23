//
//  OfficialNotificationRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 公式お知らせリポジトリ
final class OfficialNotificationRepository: OfficialNotificationRepositoryProtocol {
    
    func fetchOfficialNotification() async throws -> OfficialNotification {
        let notification = OfficialNotification(
            content: "",
        )
        return notification
    }
    
}
