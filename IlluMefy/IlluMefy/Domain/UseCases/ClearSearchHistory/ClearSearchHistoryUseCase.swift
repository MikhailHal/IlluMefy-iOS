//
//  ClearSearchHistoryUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/17.
//

import Foundation

/// 検索履歴全削除UseCase
final class ClearSearchHistoryUseCase {
    private let searchHistoryRepository: SearchHistoryRepositoryProtocol
    
    init(searchHistoryRepository: SearchHistoryRepositoryProtocol) {
        self.searchHistoryRepository = searchHistoryRepository
    }
    
    func execute() async throws {
        try await searchHistoryRepository.clearAllSearchHistory()
    }
}