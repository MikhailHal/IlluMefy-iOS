//
//  AlgoliaRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation

/// Algolia検索リポジトリプロトコル
protocol AlgoliaRepositoryProtocol {
    /// 初期化処理
    func initialize() async
    
    /// タグ検索
    func searchTags(query: String, limit: Int) async throws -> SearchTagsResponse
}

/// Algoliaエラー
enum AlgoliaError: Error {
    case notInitialized
    case searchFailed(String)
    case invalidResponse
}
