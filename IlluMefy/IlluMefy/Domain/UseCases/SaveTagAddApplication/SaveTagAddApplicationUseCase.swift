//
//  SaveTagAddApplicationUseCase.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation
import FirebaseAuth

/// タグ追加申請保存 UseCase 実装
class SaveTagAddApplicationUseCase: SaveTagAddApplicationUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let repository: TagAddApplicationRepositoryProtocol
    
    // MARK: - Initializer
    
    init(repository: TagAddApplicationRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - UseCase Implementation
    
    func execute(_ request: SaveTagAddApplicationUseCaseRequest) async throws {
        do {
            try request.validate()
            let tagAddApplication = TagAddApplication(
                name: request.tagName,
                userUid: request.userUid,
                createdAt: Date(),
            )
        
            let repositoryRequest = SaveTagAddApplicationRequest(
                name: tagAddApplication.name,
                userUid: tagAddApplication.userUid,
                createdAt: tagAddApplication.createdAt,
                state: tagAddApplication.state
            )
            try await repository.saveTagAddApplication(repositoryRequest)
            
        } catch let error as SaveTagAddApplicationUseCaseError {
            throw error
        } catch let error as TagAddApplicationRepositoryError {
            throw SaveTagAddApplicationUseCaseError.repositoryError(error)
        } catch {
            throw SaveTagAddApplicationUseCaseError.unknownError
        }
    }
}
