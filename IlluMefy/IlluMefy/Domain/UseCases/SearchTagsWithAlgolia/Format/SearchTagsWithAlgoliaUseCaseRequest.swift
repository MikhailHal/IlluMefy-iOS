//
//  SearchTagsWithAlgoliaUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation

/// Algoliaタグ検索UseCaseリクエスト
public struct SearchTagsWithAlgoliaUseCaseRequest {
    /// 検索クエリ
    let query: String
    
    /// 取得件数上限
    let limit: Int
    
    public init(
        query: String,
        limit: Int = 20
    ) {
        self.query = query
        self.limit = limit
    }
}