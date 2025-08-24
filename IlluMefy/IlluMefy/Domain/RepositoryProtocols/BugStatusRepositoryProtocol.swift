//
//  BugStatusRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/24.
//

import Foundation

/// バグ状況リポジトリプロトコル
protocol BugStatusRepositoryProtocol {
    /// バグ状況を取得
    /// - Returns: バグ状況エンティティ
    /// - Throws: リポジトリエラー
    func fetchBugStatus() async throws -> BugStatus
}