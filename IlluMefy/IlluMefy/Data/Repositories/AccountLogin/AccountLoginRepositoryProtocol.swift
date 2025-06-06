//
//  AccountLoginRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/04/03.
//

protocol AccountLoginRepositoryProtocol: Sendable {
    func login(_ request: AccountLoginRequest) async throws -> Bool
    
    /// アカウントを作成
    /// - Parameter request: 作成リクエスト
    /// - Returns: 作成レスポンス
    /// - Throws: AccountLoginRepositoryError
    func createAccount(request: CreateAccountRequest) async throws -> CreateAccountResponse
}
