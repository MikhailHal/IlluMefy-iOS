//
//  SaveSearchHistoryUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 検索履歴保存UseCase
final class SaveSearchHistoryUseCase {
    private let repository: SearchHistoryRepositoryProtocol
    
    init(repository: SearchHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String) async throws {
        try await repository.saveSearchHistory(query: query)
    }
}