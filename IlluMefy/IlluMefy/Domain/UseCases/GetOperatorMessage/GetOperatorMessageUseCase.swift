//
//  GetOperatorMessageUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/27.
//

import Foundation

/// 運営メッセージ取得UseCase
final class GetOperatorMessageUseCase: GetOperatorMessageUseCaseProtocol {
    
    // MARK: - Properties
    private let operatorMessageRepository: OperatorMessageRepositoryProtocol
    
    // MARK: - Initialization
    init(operatorMessageRepository: OperatorMessageRepositoryProtocol) {
        self.operatorMessageRepository = operatorMessageRepository
    }
    
    // MARK: - GetOperatorMessageUseCaseProtocol
    
    func fetchAndCacheOperatorMessage() async throws -> OperatorMessage? {
        // サーバーから最新のメッセージを取得し、自動的にキャッシュ
        return try await operatorMessageRepository.fetchOperatorMessage()
    }
    
    func getCachedOperatorMessage() -> OperatorMessage? {
        return operatorMessageRepository.getCachedOperatorMessage()
    }
}