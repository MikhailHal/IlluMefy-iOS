//
//  SaveTagAddApplicationUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ追加申請保存 UseCase プロトコル
protocol SaveTagAddApplicationUseCaseProtocol {
    func execute(_ request: SaveTagAddApplicationUseCaseRequest) async throws
}