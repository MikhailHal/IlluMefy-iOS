//
//  SubmitProfileCorrectionUseCaseProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼送信ユースケースプロトコル
protocol SubmitProfileCorrectionUseCaseProtocol {
    /// 修正依頼を送信する
    /// - Parameter request: 修正依頼リクエスト
    /// - Returns: 修正依頼レスポンス
    func execute(_ request: SubmitProfileCorrectionUseCaseRequest) async -> SubmitProfileCorrectionUseCaseResponse
}