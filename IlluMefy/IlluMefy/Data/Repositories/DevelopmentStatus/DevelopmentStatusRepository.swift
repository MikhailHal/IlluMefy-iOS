//
//  DevelopmentStatusRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/23.
//

import Foundation
import FirebaseRemoteConfig

/// 開発状況リポジトリ
final class DevelopmentStatusRepository: DevelopmentStatusRepositoryProtocol {
    let developmentStatusKey = "development_status_content"
    let firebaseRemoteConfig: FirebaseRemoteConfigProtocol
    
    init(firebaseRemoteConfig: FirebaseRemoteConfigProtocol) {
        self.firebaseRemoteConfig = firebaseRemoteConfig
    }
    
    func fetchDevelopmentStatus() async throws -> DevelopmentStatus {
        let content = self.firebaseRemoteConfig.fetchValue(key: developmentStatusKey) as String? ?? ""
        let developmentStatus = DevelopmentStatus(
            content: content
        )
        return developmentStatus
    }
}