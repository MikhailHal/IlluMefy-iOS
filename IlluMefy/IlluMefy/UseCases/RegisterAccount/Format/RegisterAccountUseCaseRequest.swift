//
//  RegisterAccountUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  アカウント登録リクエスト
//

import Foundation

/// アカウント登録ユースケースのリクエスト
struct RegisterAccountUseCaseRequest {
    /// 電話番号
    let phoneNumber: String
    
    /// Firebase認証のcredential（電話番号認証済み）
    let credential: Any
}
