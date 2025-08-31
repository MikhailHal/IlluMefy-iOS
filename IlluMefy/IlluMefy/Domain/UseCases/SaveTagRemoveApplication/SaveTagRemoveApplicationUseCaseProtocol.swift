//
//  SaveTagRemoveApplicationUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ削除申請保存 UseCase プロトコル
protocol SaveTagRemoveApplicationUseCaseProtocol {
    func execute(_ request: SaveTagRemoveApplicationUseCaseRequest) async throws
}