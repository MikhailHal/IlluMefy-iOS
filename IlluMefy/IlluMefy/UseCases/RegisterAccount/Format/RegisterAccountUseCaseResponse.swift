//
//  RegisterAccountUseCaseResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/06.
//
//  アカウント登録レスポンス
//

import Foundation

/// アカウント登録ユースケースのレスポンス
struct RegisterAccountUseCaseResponse {
    /// 作成されたユーザーのID
    let userID: String
    
    /// 電話番号
    let phoneNumber: String
}
