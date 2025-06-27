//
//  GetContactSupportHistoryUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import Foundation

protocol GetContactSupportHistoryUseCaseProtocol {
    func execute(userId: String) async throws -> [ContactSupport]
}

class GetContactSupportHistoryUseCase: GetContactSupportHistoryUseCaseProtocol {
    
    // MARK: - Dependencies
    private let repository: ContactSupportRepositoryProtocol
    
    // MARK: - Initializer
    init(repository: ContactSupportRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - GetContactSupportHistoryUseCaseProtocol
    func execute(userId: String) async throws -> [ContactSupport] {
        // バリデーション
        guard !userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ContactSupportError.unauthorized
        }
        
        // リポジトリ経由で履歴取得
        let history = try await repository.getContactSupportHistory(userId: userId)
        
        // 送信日時でソート（新しい順）
        return history.sorted { $0.submittedAt > $1.submittedAt }
    }
}