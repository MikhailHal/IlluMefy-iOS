//
//  DevelopmentStatusRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/23.
//

import Foundation

/// 開発状況リポジトリプロトコル
protocol DevelopmentStatusRepositoryProtocol {
    /// 開発状況を取得
    /// - Returns: 開発状況エンティティ
    /// - Throws: リポジトリエラー
    func fetchDevelopmentStatus() async throws -> DevelopmentStatus
}