//
//  SaveTagRemoveApplicationUseCase.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ削除申請保存 UseCase 実装
class SaveTagRemoveApplicationUseCase: SaveTagRemoveApplicationUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: TagRemoveApplicationRepositoryProtocol
    
    // MARK: - Initializer
    
    init(repository: TagRemoveApplicationRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - UseCase Implementation
    
    func execute(_ request: SaveTagRemoveApplicationUseCaseRequest) async throws {
        do {
            try request.validate()
            let tagRemoveApplication = TagRemoveApplication(
                name: request.tagName,
                userUid: request.userUid,
                creatorId: request.creatorId,
                createdAt: Date()
            )
        
            let repositoryRequest = SaveTagRemoveApplicationRequest(
                name: tagRemoveApplication.name,
                userUid: tagRemoveApplication.userUid,
                creatorId: tagRemoveApplication.creatorId,
                createdAt: tagRemoveApplication.createdAt,
                state: tagRemoveApplication.state
            )
            try await repository.saveTagRemoveApplication(repositoryRequest)
            
        } catch let error as SaveTagRemoveApplicationUseCaseError {
            throw error
        } catch let error as TagRemoveApplicationRepositoryError {
            throw SaveTagRemoveApplicationUseCaseError.repositoryError(error)
        } catch {
            throw SaveTagRemoveApplicationUseCaseError.unknownError
        }
    }
}