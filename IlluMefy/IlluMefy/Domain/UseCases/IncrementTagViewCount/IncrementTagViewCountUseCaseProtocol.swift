//
//  IncrementTagViewCountUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ閲覧数増加 UseCase プロトコル
protocol IncrementTagViewCountUseCaseProtocol {
    func execute(_ request: IncrementTagViewCountUseCaseRequest) async throws
}