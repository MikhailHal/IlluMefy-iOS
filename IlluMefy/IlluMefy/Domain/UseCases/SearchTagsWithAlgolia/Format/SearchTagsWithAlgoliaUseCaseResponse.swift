//
//  SearchTagsWithAlgoliaUseCaseResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation

/// Algoliaタグ検索UseCaseレスポンス
public struct SearchTagsWithAlgoliaUseCaseResponse {
    /// 検索候補一覧
    let suggestions: [TagSuggestion]
    
    /// 総件数
    let totalCount: Int
    
    public init(
        suggestions: [TagSuggestion],
        totalCount: Int
    ) {
        self.suggestions = suggestions
        self.totalCount = totalCount
    }
}