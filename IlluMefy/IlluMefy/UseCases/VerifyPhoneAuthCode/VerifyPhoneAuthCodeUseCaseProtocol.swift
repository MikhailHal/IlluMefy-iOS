//
//  VerifyPhoneAuthCodeUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  電話番号認証コード検証ユースケースのプロトコル
//

import Foundation

/// 電話番号認証コード検証ユースケースのプロトコル
protocol VerifyPhoneAuthCodeUseCaseProtocol: Sendable {
    /// 認証コードを検証する
    /// - Parameter request: 検証リクエスト
    /// - Returns: 検証レスポンス（credential含む）
    /// - Throws: VerifyPhoneAuthCodeUseCaseError
    func execute(request: VerifyPhoneAuthCodeUseCaseRequest) async throws -> VerifyPhoneAuthCodeUseCaseResponse
}
