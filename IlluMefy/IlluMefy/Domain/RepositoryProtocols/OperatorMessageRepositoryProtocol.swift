//
//  OperatorMessageRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 運営メッセージリポジトリのプロトコル
protocol OperatorMessageRepositoryProtocol {
    /// 運営メッセージを取得（サーバーから）
    func fetchOperatorMessage() async throws -> OperatorMessage?
    
    /// キャッシュされた運営メッセージを取得
    func getCachedOperatorMessage() -> OperatorMessage?
    
    /// 運営メッセージをキャッシュに保存
    func cacheOperatorMessage(_ message: OperatorMessage?)
    
    /// キャッシュをクリア
    func clearCache()
}