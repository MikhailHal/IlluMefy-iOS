//
//  SubmitProfileCorrectionUseCaseResponse.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼送信ユースケースレスポンス
struct SubmitProfileCorrectionUseCaseResponse: Equatable {
    /// 成功可否
    let isSuccess: Bool
    
    /// 送信された修正依頼（成功時）
    let correctionRequest: ProfileCorrectionRequest?
    
    /// エラー（失敗時）
    let error: SubmitProfileCorrectionUseCaseError?
    
    /// 成功レスポンスを作成
    /// - Parameter correctionRequest: 送信された修正依頼
    /// - Returns: 成功レスポンス
    static func success(_ correctionRequest: ProfileCorrectionRequest) -> SubmitProfileCorrectionUseCaseResponse {
        return SubmitProfileCorrectionUseCaseResponse(
            isSuccess: true,
            correctionRequest: correctionRequest,
            error: nil
        )
    }
    
    /// 失敗レスポンスを作成
    /// - Parameter error: エラー
    /// - Returns: 失敗レスポンス
    static func failure(_ error: SubmitProfileCorrectionUseCaseError) -> SubmitProfileCorrectionUseCaseResponse {
        return SubmitProfileCorrectionUseCaseResponse(
            isSuccess: false,
            correctionRequest: nil,
            error: error
        )
    }
}