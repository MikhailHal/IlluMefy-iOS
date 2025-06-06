//
//  VerifyPhoneAuthCodeResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  電話番号認証コード検証レスポンス（Repository層）
//

import Foundation

/// 電話番号認証コード検証のレスポンス
struct VerifyPhoneAuthCodeResponse {
    /// Firebase認証のcredential
    let credential: Any
}
