//
//  PhoneAuthRequest.swift
//  IlluMefy
//
//  電話番号認証リポジトリのリクエスト
//

import Foundation

/// 電話番号認証コード送信リクエスト
struct SendVerificationCodeRequest {
    /// E.164形式の電話番号（例: +819012345678）
    let phoneNumber: String
}

/// 認証コード確認リクエスト
struct VerifyCodeRequest {
    /// ユーザーが入力した6桁の認証コード
    let verificationCode: String
    /// sendVerificationCodeで取得した検証ID
    let verificationID: String
}