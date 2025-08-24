//
//  BugStatusRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/24.
//

import Foundation
import FirebaseRemoteConfig

/// バグ状況リポジトリ
final class BugStatusRepository: BugStatusRepositoryProtocol {
    let bugStatusKey = "bug_status_content"
    let firebaseRemoteConfig: FirebaseRemoteConfigProtocol
    
    init(firebaseRemoteConfig: FirebaseRemoteConfigProtocol) {
        self.firebaseRemoteConfig = firebaseRemoteConfig
    }
    
    func fetchBugStatus() async throws -> BugStatus {
        let content = self.firebaseRemoteConfig.fetchValue(key: bugStatusKey) as String? ?? ""
        let bugStatus = BugStatus(
            content: content
        )
        return bugStatus
    }
}