//
//  RegisterAccountUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  アカウント登録ユースケースのプロトコル
//

import Foundation

/// アカウント登録ユースケースのプロトコル
protocol RegisterAccountUseCaseProtocol: Sendable {
    /// アカウントを登録する
    /// - Parameter request: 登録リクエスト
    /// - Returns: 登録レスポンス
    /// - Throws: RegisterAccountUseCaseError
    func execute(request: RegisterAccountUseCaseRequest) async throws -> RegisterAccountUseCaseResponse
}
