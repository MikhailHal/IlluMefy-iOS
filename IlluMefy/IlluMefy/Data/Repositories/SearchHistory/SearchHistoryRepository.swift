//
//  SearchHistoryRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 検索履歴リポジトリ（UserDefaults使用）
final class SearchHistoryRepository: SearchHistoryRepositoryProtocol {
    private let userDefaults: UserDefaults
    private let key = "search_history"
    private let maxHistoryCount = 10
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveSearchHistory(query: String) async throws {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        var history = try await getSearchHistory(limit: maxHistoryCount)
        
        // 既存の同じクエリを削除
        history.removeAll { $0 == trimmedQuery }
        
        // 先頭に追加
        history.insert(trimmedQuery, at: 0)
        
        // 上限を超えたら削除
        if history.count > maxHistoryCount {
            history = Array(history.prefix(maxHistoryCount))
        }
        
        userDefaults.set(history, forKey: key)
    }
    
    func getSearchHistory(limit: Int) async throws -> [String] {
        let history = userDefaults.stringArray(forKey: key) ?? []
        return Array(history.prefix(limit))
    }
    
    func deleteSearchHistory(query: String) async throws {
        var history = try await getSearchHistory(limit: maxHistoryCount)
        history.removeAll { $0 == query }
        userDefaults.set(history, forKey: key)
    }
    
    func clearAllSearchHistory() async throws {
        userDefaults.removeObject(forKey: key)
    }
}