//
//  SearchCreatorsByNameUseCaseResponse.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でクリエイターを検索するUseCaseのレスポンス
struct SearchCreatorsByNameUseCaseResponse {
    /// 検索結果のクリエイター一覧
    let creators: [Creator]
    
    /// 検索にヒットした総件数
    let totalCount: Int
    
    /// 次のページがあるかどうか
    let hasMore: Bool
}