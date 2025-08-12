//
//  CreatorRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/**
 クリエイター読み取り専用リポジトリプロトコル
 
 クリエイターデータの取得に関する操作を定義します。
 Clean Architectureの依存性逆転原則に従い、Domain層に配置されています。
 */
protocol CreatorRepositoryProtocol {
    
    /// 全クリエイターを取得
    /// 
    /// - Returns: 全クリエイターの配列
    /// - Throws: RepositoryError
    func getAllCreators() async throws -> [Creator]
    
    /// 指定日時以降に更新されたクリエイターを取得（差分取得）
    /// 
    /// - Parameter date: 基準となる日時
    /// - Returns: 更新されたクリエイターの配列
    /// - Throws: RepositoryError
    func getCreatorsUpdatedAfter(date: Date) async throws -> [Creator]
    
    /// タグによるクリエイター検索
    /// 
    /// - Parameter tagIds: 検索するタグIDの配列
    /// - Returns: 条件に一致するクリエイターの配列
    /// - Throws: RepositoryError
    func searchCreatorsByTags(tagIds: [String]) async throws -> [Creator]
    
    /// タグによるクリエイター検索（拡張版）
    /// 
    /// - Parameters:
    ///   - tagIds: 検索するタグIDの配列
    ///   - searchMode: 検索モード（AND/OR）
    ///   - sortOrder: ソート順
    ///   - offset: ページネーション用のオフセット
    ///   - limit: 1ページあたりの取得件数
    /// - Returns: 検索結果
    /// - Throws: RepositoryError
    func searchByTags(
        tagIds: [String],
        searchMode: TagSearchMode,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult
    
    /// 人気のクリエイターを取得
    /// 
    /// - Parameter limit: 取得する件数の上限
    /// - Returns: 人気順にソートされたクリエイターの配列
    /// - Throws: RepositoryError
    func getPopularCreators(limit: Int) async throws -> GetPopularCreatorsResponse
    
    /// 最新のクリエイターを取得
    ///
    /// - Parameter limit: 取得する件数の上限
    /// - Returns: 人気順にソートされたクリエイターの配列
    /// - Throws: RepositoryError
    func getNewestCreators(limit: Int) async throws -> GetNewestCreatorsResponse
    
    /// 指定IDのクリエイターを取得
    /// 
    /// - Parameter id: クリエイターID
    /// - Returns: 指定されたクリエイター
    /// - Throws: RepositoryError
    func getCreatorById(id: String) async throws -> Creator
    
    /// 類似クリエイターを取得
    /// 
    /// - Parameter creatorId: 基準となるクリエイターID
    /// - Parameter limit: 取得する件数の上限
    /// - Returns: 類似度順にソートされたクリエイターの配列
    /// - Throws: RepositoryError
    func getSimilarCreators(creatorId: String, limit: Int) async throws -> [Creator]
    
    /// 名前でクリエイターを検索
    /// 
    /// - Parameters:
    ///   - query: 検索クエリ
    ///   - sortOrder: ソート順
    ///   - offset: ページネーション用のオフセット
    ///   - limit: 1ページあたりの取得件数
    /// - Returns: 検索結果
    /// - Throws: RepositoryError
    func searchByName(
        query: String,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult
}
