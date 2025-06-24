//
//  FavoriteViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/24.
//

import Foundation

/// お気に入り画面のViewModelプロトコル
@MainActor
protocol FavoriteViewModelProtocol: ObservableObject {
    /// お気に入りクリエイターリスト
    var favoriteCreators: [Creator] { get }
    
    /// ローディング状態
    var isLoading: Bool { get }
    
    /// お気に入りクリエイターを読み込む
    func loadFavoriteCreators() async
    
    /// お気に入りから削除
    func removeFavorite(creatorId: String) async
}