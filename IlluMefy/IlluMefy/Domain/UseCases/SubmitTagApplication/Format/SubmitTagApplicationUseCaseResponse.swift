//
//  SubmitTagApplicationUseCaseResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請送信 UseCase レスポンス
struct SubmitTagApplicationUseCaseResponse {
    /// 申請ID
    let applicationId: String
    
    /// 申請状態
    let status: TagApplicationResponse.ApplicationStatus
    
    /// 申請受付日時
    let submittedAt: Date
    
    /// メッセージ
    let message: String
    
    init(application: TagApplication) {
        self.applicationId = application.id
        self.status = application.status
        self.submittedAt = application.requestedAt
        self.message = "タグ申請を受け付けました。審査結果をお待ちください。"
    }
}