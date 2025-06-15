//
//  SearchTagsByNameUseCaseRequest.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でタグを検索するUseCaseのリクエスト
struct SearchTagsByNameUseCaseRequest {
    /// AND検索クエリ（すべてのキーワードを含む）
    let andQuery: String
    
    /// OR検索クエリ（いずれかのキーワードを含む）
    let orQuery: String
    
    /// ページネーション用のオフセット
    let offset: Int
    
    /// 1ページあたりの取得件数
    let limit: Int
    
    init(
        andQuery: String = "",
        orQuery: String = "",
        offset: Int = 0,
        limit: Int = 20
    ) {
        self.andQuery = andQuery
        self.orQuery = orQuery
        self.offset = offset
        self.limit = limit
    }
}