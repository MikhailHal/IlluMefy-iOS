//
//  CreatorDetailViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/**
 クリエイター詳細画面のViewModelプロトコル
 
 クリエイター詳細画面のビジネスロジックと状態管理のインターフェースを定義します。
 */
@MainActor
protocol CreatorDetailViewModelProtocol {
    /// クリエイター情報
    var creator: Creator { get }
    
    /// タグ情報
    var tags: [Tag] { get set }
    
    /// 類似クリエイター
    var similarCreators: [Creator] { get set }
    
    /// ローディング状態
    var isLoadingTags: Bool { get set }
    
    /// お気に入り状態
    var isFavorite: Bool { get set }
    
    /// エラーメッセージ
    var errorMessage: String? { get set }
    
    /// タグ情報を読み込む
    func loadTags() async
    
    /// お気に入り状態を切り替える
    func toggleFavorite()
}
