//
//  GetDevelopmentStatusUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/23.
//

import Foundation

/// 開発状況取得ユースケースプロトコル
protocol GetDevelopmentStatusUseCaseProtocol {
    /// 開発状況を取得
    /// - Returns: 開発状況エンティティ
    /// - Throws: ユースケースエラー
    func execute() async throws -> DevelopmentStatus
}