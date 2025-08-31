//
//  TagRemoveApplicationRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ削除申請Repository プロトコル
protocol TagRemoveApplicationRepositoryProtocol {
    /// タグ削除申請をFirestoreに保存
    func saveTagRemoveApplication(_ request: SaveTagRemoveApplicationRequest) async throws
}