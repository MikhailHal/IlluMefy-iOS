//
//  CreateAccountResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  アカウント作成レスポンス（Repository層）
//

import Foundation

/// アカウント作成のレスポンス
struct CreateAccountResponse {
    /// 作成されたユーザーのID
    let userID: String
    
    /// 電話番号
    let phoneNumber: String
}
