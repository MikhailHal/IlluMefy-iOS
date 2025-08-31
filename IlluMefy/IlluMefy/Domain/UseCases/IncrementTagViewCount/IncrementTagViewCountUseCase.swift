//
//  IncrementTagViewCountUseCase.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ閲覧数増加 UseCase 実装
class IncrementTagViewCountUseCase: IncrementTagViewCountUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: TagViewCountRepositoryProtocol
    
    // MARK: - Initializer
    
    init(repository: TagViewCountRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - UseCase Implementation
    
    func execute(_ request: IncrementTagViewCountUseCaseRequest) async throws {
        do {
            try request.validate()
            
            let repositoryRequest = IncrementTagViewCountRequest(
                tagId: request.tagId,
                incrementedAt: Date()
            )
            
            try await repository.incrementTagViewCount(repositoryRequest)
            
        } catch let error as IncrementTagViewCountUseCaseError {
            throw error
        } catch let error as TagViewCountRepositoryError {
            throw IncrementTagViewCountUseCaseError.repositoryError(error)
        } catch {
            throw IncrementTagViewCountUseCaseError.unknownError
        }
    }
}