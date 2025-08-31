//
//  TagViewCountRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ閲覧数Repository プロトコル
protocol TagViewCountRepositoryProtocol {
    /// タグの閲覧数をインクリメント
    func incrementTagViewCount(_ request: IncrementTagViewCountRequest) async throws
}