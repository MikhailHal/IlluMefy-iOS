//
//  SearchCreatorsByNameUseCaseRequest.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でクリエイターを検索するUseCaseのリクエスト
struct SearchCreatorsByNameUseCaseRequest {
    /// 検索クエリ
    let query: String
    
    /// ソート順
    let sortOrder: CreatorSortOrder
    
    /// ページネーション用のオフセット
    let offset: Int
    
    /// 1ページあたりの取得件数
    let limit: Int
    
    init(
        query: String,
        sortOrder: CreatorSortOrder = .popularity,
        offset: Int = 0,
        limit: Int = 20
    ) {
        self.query = query
        self.sortOrder = sortOrder
        self.offset = offset
        self.limit = limit
    }
}

/// クリエイターのソート順
public enum CreatorSortOrder {
    case popularity // 人気順
    case newest     // 新着順
    case name       // 名前順（五十音）
}