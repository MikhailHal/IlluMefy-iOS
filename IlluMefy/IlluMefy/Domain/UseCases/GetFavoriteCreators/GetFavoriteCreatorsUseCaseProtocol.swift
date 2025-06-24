//
//  GetFavoriteCreatorsUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/24.
//

import Foundation

/// お気に入りクリエイター取得ユースケースプロトコル
protocol GetFavoriteCreatorsUseCaseProtocol {
    func execute() async throws -> [Creator]
}