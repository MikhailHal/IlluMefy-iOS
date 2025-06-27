//
//  GetOperatorMessageUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 運営メッセージ取得UseCaseのプロトコル
protocol GetOperatorMessageUseCaseProtocol {
    /// サーバーから運営メッセージを取得してキャッシュに保存
    func fetchAndCacheOperatorMessage() async throws -> OperatorMessage?
    
    /// キャッシュされた運営メッセージを取得
    func getCachedOperatorMessage() -> OperatorMessage?
}