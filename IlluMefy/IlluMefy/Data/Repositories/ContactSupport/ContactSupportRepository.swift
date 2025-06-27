//
//  ContactSupportRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import Foundation

class ContactSupportRepository: ContactSupportRepositoryProtocol {
    
    // MARK: - Dependencies
    // TODO: API ClientやFirebase関連の依存性を追加
    
    init() {
        // TODO: 依存性の初期化
    }
    
    // MARK: - ContactSupportRepositoryProtocol
    
    func submitContactSupport(_ request: ContactSupportRequest) async throws -> ContactSupport {
        // TODO: API呼び出しでサーバーにお問い合わせを送信
        // 現在はモック実装
        
        // API呼び出しのシミュレーション
        try await Task.sleep(nanoseconds: 2_000_000_000) // 2秒待機
        
        // ランダムでエラーを発生させる（テスト用）
        if Bool.random() && false { // falseにしてエラーを無効化
            throw ContactSupportError.networkError
        }
        
        // モックレスポンス
        let contactSupport = ContactSupport(
            type: request.type,
            content: request.content,
            userId: request.userId
        )
        
        return contactSupport
    }
    
    func getContactSupportHistory(userId: String) async throws -> [ContactSupport] {
        // TODO: API呼び出しでユーザーのお問い合わせ履歴を取得
        // 現在はモック実装
        
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1秒待機
        
        // モックデータ
        let mockHistory: [ContactSupport] = [
            ContactSupport(
                id: UUID().uuidString,
                type: .bugReport,
                content: "ログイン時にアプリがクラッシュします",
                submittedAt: Date().addingTimeInterval(-86400 * 3), // 3日前
                status: .resolved,
                userId: userId
            ),
            ContactSupport(
                id: UUID().uuidString,
                type: .featureRequest,
                content: "お気に入りのフォルダ機能を追加してほしいです",
                submittedAt: Date().addingTimeInterval(-86400 * 7), // 1週間前
                status: .reviewing,
                userId: userId
            )
        ]
        
        return mockHistory
    }
    
    func getContactSupport(id: String) async throws -> ContactSupport {
        // TODO: API呼び出しで特定のお問い合わせを取得
        // 現在はモック実装
        
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒待機
        
        // モックデータ
        let mockContactSupport = ContactSupport(
            id: id,
            type: .bugReport,
            content: "サンプルお問い合わせ内容",
            userId: "mock-user-id"
        )
        
        return mockContactSupport
    }
}

// MARK: - Private Methods
private extension ContactSupportRepository {
    
    // TODO: API関連のヘルパーメソッドを追加
    
    /// APIエラーをContactSupportErrorに変換
    func mapToContactSupportError(_ error: Error) -> ContactSupportError {
        // TODO: 実際のAPIエラーレスポンスに基づいてエラーマッピングを実装
        switch error {
        case is URLError:
            return .networkError
        default:
            return .unknown
        }
    }
}