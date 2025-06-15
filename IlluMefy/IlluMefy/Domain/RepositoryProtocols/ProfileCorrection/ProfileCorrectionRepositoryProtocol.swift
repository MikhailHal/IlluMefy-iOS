//
//  ProfileCorrectionRepositoryProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼リポジトリプロトコル
protocol ProfileCorrectionRepositoryProtocol {
    /// 修正依頼を送信する
    /// - Parameter request: 修正依頼エンティティ
    /// - Returns: 送信結果
    func submitCorrectionRequest(_ request: ProfileCorrectionRequest) async throws -> ProfileCorrectionRequest
    
    /// ユーザーの修正依頼履歴を取得する
    /// - Parameters:
    ///   - userId: ユーザーID
    ///   - limit: 取得件数上限
    /// - Returns: 修正依頼リスト
    func getCorrectionHistory(userId: String, limit: Int) async throws -> [ProfileCorrectionRequest]
    
    /// 修正依頼の詳細を取得する
    /// - Parameter requestId: 修正依頼ID
    /// - Returns: 修正依頼エンティティ
    func getCorrectionRequest(requestId: String) async throws -> ProfileCorrectionRequest
    
    /// 修正依頼をキャンセルする
    /// - Parameter requestId: 修正依頼ID
    /// - Returns: キャンセル成功可否
    func cancelCorrectionRequest(requestId: String) async throws -> Bool
}