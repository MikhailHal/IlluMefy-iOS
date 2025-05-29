//
//  SendPhoneVerificationUseCaseResponse.swift
//  IlluMefy
//
//  電話番号認証コード送信ユースケースのレスポンス
//

import Foundation

/// 電話番号認証コード送信ユースケースのレスポンス
struct SendPhoneVerificationUseCaseResponse {
    /// 検証ID（認証コード確認時に使用）
    let verificationID: String
}
