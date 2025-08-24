//
//  GetBugStatusUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/24.
//

import Foundation

/// バグ状況取得ユースケースプロトコル
protocol GetBugStatusUseCaseProtocol {
    /// バグ状況を取得
    /// - Returns: バグ状況エンティティ
    /// - Throws: ユースケースエラー
    func execute() async throws -> BugStatus
}