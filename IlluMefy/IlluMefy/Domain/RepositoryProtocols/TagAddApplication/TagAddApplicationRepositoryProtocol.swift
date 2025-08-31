//
//  TagAddApplicationRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ追加申請Repository プロトコル
protocol TagAddApplicationRepositoryProtocol {
    /// タグ追加申請をFirestoreに保存
    func saveTagAddApplication(_ request: SaveTagAddApplicationRequest) async throws
}