//
//  GetSearchHistoryUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 検索履歴取得UseCase
final class GetSearchHistoryUseCase {
    private let repository: SearchHistoryRepositoryProtocol
    
    init(repository: SearchHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(limit: Int = 10) async throws -> [String] {
        return try await repository.getSearchHistory(limit: limit)
    }
}