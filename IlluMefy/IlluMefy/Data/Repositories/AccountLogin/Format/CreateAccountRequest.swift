//
//  CreateAccountRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  アカウント作成リクエスト（Repository層）
//

import Foundation

/// アカウント作成のリクエスト
struct CreateAccountRequest {
    /// 電話番号
    let phoneNumber: String
    
    /// Firebase認証のcredential
    let credential: Any
}
