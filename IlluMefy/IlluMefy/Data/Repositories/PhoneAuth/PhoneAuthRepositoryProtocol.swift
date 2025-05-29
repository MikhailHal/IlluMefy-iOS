//
//  PhoneAuthRepositoryProtocol.swift
//  IlluMefy
//
//  電話番号認証に関するリポジトリプロトコル
//

import Foundation

/// 電話番号認証リポジトリのプロトコル
protocol PhoneAuthRepositoryProtocol {
    /// 認証コードを送信
    /// - Parameter request: 送信リクエスト
    /// - Returns: 送信レスポンス
    /// - Throws: PhoneAuthRepositoryError
    func sendVerificationCode(request: SendVerificationCodeRequest) async throws -> SendVerificationCodeResponse
    
    /// 認証コードを検証してサインイン
    /// - Parameter request: 検証リクエスト
    /// - Returns: 検証レスポンス
    /// - Throws: PhoneAuthRepositoryError
    func verifyCode(request: VerifyCodeRequest) async throws -> VerifyCodeResponse
}
