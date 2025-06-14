//
//  SubmitTagApplicationUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請送信 UseCase プロトコル
protocol SubmitTagApplicationUseCaseProtocol {
    /// タグ申請を送信
    /// - Parameter request: 申請リクエスト
    /// - Returns: 申請結果
    /// - Throws: UseCase エラー
    func execute(_ request: SubmitTagApplicationUseCaseRequest) async throws -> SubmitTagApplicationUseCaseResponse
}
