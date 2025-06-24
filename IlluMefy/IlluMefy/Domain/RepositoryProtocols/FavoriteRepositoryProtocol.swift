//
//  FavoriteRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/24.
//

import Foundation

/// お気に入りリポジトリプロトコル
protocol FavoriteRepositoryProtocol {
    /// お気に入りクリエイターIDの一覧を取得
    func getFavoriteCreatorIds() async throws -> [String]
    
    /// クリエイターをお気に入りに追加
    func addFavoriteCreator(creatorId: String) async throws
    
    /// クリエイターをお気に入りから削除
    func removeFavoriteCreator(creatorId: String) async throws
    
    /// クリエイターがお気に入りに登録されているか確認
    func isFavorite(creatorId: String) async throws -> Bool
}