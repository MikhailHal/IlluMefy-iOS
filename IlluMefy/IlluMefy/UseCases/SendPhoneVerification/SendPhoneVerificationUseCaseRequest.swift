//
//  SendPhoneVerificationUseCaseRequest.swift
//  IlluMefy
//
//  電話番号認証コード送信ユースケースのリクエスト
//

import Foundation

/// 電話番号認証コード送信ユースケースのリクエスト
struct SendPhoneVerificationUseCaseRequest {
    /// 電話番号（国内番号形式: 09012345678）
    let phoneNumber: String
}