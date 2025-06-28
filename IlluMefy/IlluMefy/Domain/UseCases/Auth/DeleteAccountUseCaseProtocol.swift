//
//  DeleteAccountUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/28.
//

import Foundation

/// アカウント削除 UseCase のプロトコル
@MainActor
protocol DeleteAccountUseCaseProtocol {
    /// アカウントを削除する
    /// - Returns: 削除が成功した場合のレスポンス
    /// - Throws: DeleteAccountUseCaseError
    func execute() async throws -> DeleteAccountUseCaseResponse
}