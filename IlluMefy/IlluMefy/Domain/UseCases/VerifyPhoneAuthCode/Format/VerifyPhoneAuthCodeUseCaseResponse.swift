//
//  VerifyPhoneAuthCodeUseCaseResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  電話番号認証コード検証レスポンス
//

import Foundation

/// 電話番号認証コード検証ユースケースのレスポンス
struct VerifyPhoneAuthCodeUseCaseResponse {
    /// Firebase認証のcredential（後続のアカウント作成で使用）
    let credential: Any
}
