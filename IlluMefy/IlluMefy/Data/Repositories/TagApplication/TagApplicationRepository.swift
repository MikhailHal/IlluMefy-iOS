//
//  TagApplicationRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// タグ申請Repository実装
class TagApplicationRepository: TagApplicationRepositoryProtocol {
    
    func saveApplication(_ application: TagApplication) async throws -> TagApplication {
        // TODO: 実際のAPI呼び出しまたはデータベース保存
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒の遅延をシミュレート
        
        // モック実装: 申請を保存済み状態で返す
        return TagApplication(
            id: UUID().uuidString,
            creatorId: application.creatorId,
            tagName: application.tagName,
            reason: application.reason,
            applicationType: application.applicationType,
            status: .pending,
            requestedAt: Date(),
            reviewedAt: nil,
            reviewerId: nil,
            reviewComment: nil
        )
    }
    
    func getApplicationHistory(for creatorId: String) async throws -> [TagApplication] {
        // TODO: 実際のAPI呼び出しまたはデータベース取得
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒の遅延をシミュレート
        
        // モック実装: 空の履歴を返す
        return []
    }
    
    func getApplication(id: String) async throws -> TagApplication? {
        // TODO: 実際のAPI呼び出しまたはデータベース取得
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒の遅延をシミュレート
        
        // モック実装: nilを返す
        return nil
    }
}

/// タグ申請Repository エラー
enum TagApplicationRepositoryError: LocalizedError {
    case networkError
    case serverError(String)
    case notFound
    case duplicateApplication
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .serverError(let message):
            return "サーバーエラー: \(message)"
        case .notFound:
            return "申請が見つかりません"
        case .duplicateApplication:
            return "同じタグの申請が既に存在します"
        case .unknownError:
            return "予期しないエラーが発生しました"
        }
    }
}