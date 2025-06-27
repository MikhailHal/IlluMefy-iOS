//
//  SubmitContactSupportUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/27.
//

import Foundation

protocol SubmitContactSupportUseCaseProtocol {
    func execute(type: ContactSupportType, content: String, userId: String) async throws -> ContactSupport
}

class SubmitContactSupportUseCase: SubmitContactSupportUseCaseProtocol {
    
    // MARK: - Dependencies
    private let repository: ContactSupportRepositoryProtocol
    
    // MARK: - Initializer
    init(repository: ContactSupportRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - SubmitContactSupportUseCaseProtocol
    func execute(type: ContactSupportType, content: String, userId: String) async throws -> ContactSupport {
        // バリデーション
        try validateInput(type: type, content: content, userId: userId)
        
        // リクエスト作成
        let request = ContactSupportRequest(
            type: type,
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            userId: userId
        )
        
        // リポジトリ経由で送信
        return try await repository.submitContactSupport(request)
    }
}

// MARK: - Private Methods
private extension SubmitContactSupportUseCase {
    
    func validateInput(type: ContactSupportType, content: String, userId: String) throws {
        // ユーザーIDの検証
        guard !userId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw ContactSupportError.unauthorized
        }
        
        // コンテンツの検証
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedContent.isEmpty else {
            throw ContactSupportError.invalidContent
        }
        
        guard trimmedContent.count <= 500 else {
            throw ContactSupportError.invalidContent
        }
        
        // 最小文字数の検証（10文字以上）
        guard trimmedContent.count >= 10 else {
            throw ContactSupportError.invalidContent
        }
    }
}