//
//  GetOfficialNotificationUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 公式通知取得UseCase
final class GetOfficialNotificationUseCase: GetOfficialNotificationUseCaseProtocol {
    
    // MARK: - Properties
    private let officialNotificationRepository: OfficialNotificationRepositoryProtocol
    
    // MARK: - Initialization
    init(officialNotificationRepository: OfficialNotificationRepositoryProtocol) {
        self.officialNotificationRepository = officialNotificationRepository
    }
    
    // MARK: - GetOfficialNotificationUseCaseProtocol
    
    func fetchAndCacheOfficialNotification() async throws -> OfficialNotification? {
        // サーバーから最新の通知を取得し、自動的にキャッシュ
        return try await officialNotificationRepository.fetchOfficialNotification()
    }
    
    func getCachedOfficialNotification() -> OfficialNotification? {
        return officialNotificationRepository.getCachedOfficialNotification()
    }
}