//
//  PhoneAuthResponse.swift
//  IlluMefy
//
//  電話番号認証リポジトリのレスポンス
//

import Foundation

/// 電話番号認証コード送信レスポンス
struct SendVerificationCodeResponse {
    /// 検証ID（認証コード確認時に使用）
    let verificationID: String
}

/// 認証コード確認レスポンス
struct VerifyCodeResponse {
    /// 認証成功時のユーザーUID
    let userID: String
}