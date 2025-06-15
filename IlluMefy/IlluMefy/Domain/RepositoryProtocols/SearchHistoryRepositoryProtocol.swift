//
//  SearchHistoryRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 検索履歴リポジトリプロトコル
protocol SearchHistoryRepositoryProtocol {
    /// 検索履歴を保存
    /// - Parameter query: 検索クエリ
    func saveSearchHistory(query: String) async throws
    
    /// 検索履歴を取得
    /// - Parameter limit: 取得件数の上限
    /// - Returns: 検索履歴一覧（新しい順）
    func getSearchHistory(limit: Int) async throws -> [String]
    
    /// 検索履歴を削除
    /// - Parameter query: 削除する検索クエリ
    func deleteSearchHistory(query: String) async throws
    
    /// 全ての検索履歴を削除
    func clearAllSearchHistory() async throws
}