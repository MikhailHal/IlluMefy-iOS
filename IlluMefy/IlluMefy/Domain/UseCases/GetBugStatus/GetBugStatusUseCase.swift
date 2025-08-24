//
//  GetBugStatusUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/24.
//

import Foundation

/// バグ状況取得ユースケース
final class GetBugStatusUseCase: GetBugStatusUseCaseProtocol {
    private let repository: BugStatusRepositoryProtocol
    
    init(repository: BugStatusRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> BugStatus {
        return try await repository.fetchBugStatus()
    }
}