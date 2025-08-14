//
//  TagRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// タグ検索結果
struct TagSearchResult {
    /// 検索結果のタグ一覧
    let tags: [Tag]
    
    /// 検索にヒットした総件数
    let totalCount: Int
    
    /// 次のページがあるかどうか
    let hasMore: Bool
}

/// タグリポジトリプロトコル
protocol TagRepositoryProtocol {
    /// 名前でタグを検索（AND/OR検索対応）
    func searchByName(
        andQuery: String,
        orQuery: String,
        offset: Int,
        limit: Int
    ) async throws -> TagSearchResult
    
    /// 全タグを取得
    func getAllTags() async throws -> [Tag]
    
    /// 人気タグを取得
    func getPopularTags(limit: Int) async throws -> GetPopularTagsResponse
    
    /// タグID一覧からタグ一覧を取得
    ///
    /// - Parameter tagIdList タグID一覧
    /// - Returns タグ情報一覧
    func getTagListByIdList(tagIdList: [String]) async throws -> GetTagListByIdListResponse
}
