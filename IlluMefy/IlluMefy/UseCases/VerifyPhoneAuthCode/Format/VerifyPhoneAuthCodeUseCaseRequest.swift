//
//  VerifyPhoneAuthCodeUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  電話番号認証コード検証リクエスト
//

import Foundation

/// 電話番号認証コード検証ユースケースのリクエスト
struct VerifyPhoneAuthCodeUseCaseRequest {
    /// Firebase認証のverificationID
    let verificationID: String
    
    /// ユーザーが入力した認証コード
    let verificationCode: String
}
