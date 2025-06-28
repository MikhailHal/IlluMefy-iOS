//
//  DeleteAccountUseCaseResponse.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/28.
//

import Foundation

/// アカウント削除 UseCase レスポンス
struct DeleteAccountUseCaseResponse {
    /// 削除が成功したかどうか
    let isSuccess: Bool
    
    /// 削除完了メッセージ
    let message: String
    
    /// 削除実行日時
    let deletedAt: Date
    
    init(isSuccess: Bool = true, message: String = "アカウントが正常に削除されました", deletedAt: Date = Date()) {
        self.isSuccess = isSuccess
        self.message = message
        self.deletedAt = deletedAt
    }
}