//
//  PhoneAuthRepositoryProtocol.swift
//  IlluMefy
//
//  電話番号認証に関するリポジトリプロトコル
//

import Foundation

/// 電話番号認証リポジトリのプロトコル
protocol PhoneAuthRepositoryProtocol: Sendable {
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
    
    /// 認証コードを検証（サインインなし）
    /// - Parameter request: 検証リクエスト
    /// - Returns: 検証レスポンス（credential含む）
    /// - Throws: PhoneAuthRepositoryError
    func verifyPhoneAuthCode(request: VerifyPhoneAuthCodeRequest) async throws -> VerifyPhoneAuthCodeResponse
}
