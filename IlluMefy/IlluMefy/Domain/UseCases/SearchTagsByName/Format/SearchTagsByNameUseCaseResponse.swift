//
//  SearchTagsByNameUseCaseResponse.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でタグを検索するUseCaseのレスポンス
struct SearchTagsByNameUseCaseResponse {
    /// 検索結果のタグ一覧
    let tags: [Tag]
    
    /// 検索にヒットした総件数
    let totalCount: Int
    
    /// 次のページがあるかどうか
    let hasMore: Bool
}