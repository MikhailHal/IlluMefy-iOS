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
protocol CreatorDetailViewModelProtocol: ObservableObject {
    /// 画面の状態
    var state: CreatorDetailViewState { get set }
    
    /// お気に入り状態
    var isFavorite: Bool { get set }
    
    /// クリエイター詳細情報を読み込む
    func loadCreatorDetail() async
    
    /// お気に入り状態を切り替える
    func toggleFavorite()
}

/**
 クリエイター詳細画面の状態
 */
enum CreatorDetailViewState: Equatable {
    /// 初期状態
    case idle
    /// 読み込み中
    case loading
    /// 読み込み完了
    case loaded(creator: Creator, similarCreators: [Creator])
    /// エラー
    case error(title: String, message: String)
}
