//
//  GetDevelopmentStatusUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/23.
//

import Foundation

/// 開発状況取得ユースケース
final class GetDevelopmentStatusUseCase: GetDevelopmentStatusUseCaseProtocol {
    private let repository: DevelopmentStatusRepositoryProtocol
    
    init(repository: DevelopmentStatusRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> DevelopmentStatus {
        return try await repository.fetchDevelopmentStatus()
    }
}