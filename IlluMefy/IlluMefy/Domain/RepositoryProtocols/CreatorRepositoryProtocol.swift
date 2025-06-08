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
    
    /// 人気のクリエイターを取得
    /// 
    /// - Parameter limit: 取得する件数の上限
    /// - Returns: 人気順にソートされたクリエイターの配列
    /// - Throws: RepositoryError
    func getPopularCreators(limit: Int) async throws -> [Creator]
}
