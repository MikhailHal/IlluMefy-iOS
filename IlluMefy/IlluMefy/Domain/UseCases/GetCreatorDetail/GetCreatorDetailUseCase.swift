//
//  GetCreatorDetailUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// クリエイター詳細取得ユースケース実装
final class GetCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol {
    
    // MARK: - Dependencies
    
    private let creatorRepository: CreatorRepositoryProtocol
    
    // MARK: - Initialization
    
    init(creatorRepository: CreatorRepositoryProtocol) {
        self.creatorRepository = creatorRepository
    }
    
    // MARK: - GetCreatorDetailUseCaseProtocol
    
    func execute(request: GetCreatorDetailUseCaseRequest) async throws -> GetCreatorDetailUseCaseResponse {
        // バリデーション
        guard !request.creatorId.isEmpty else {
            throw GetCreatorDetailUseCaseError.invalidRequest
        }
        
        guard request.similarCreatorsLimit > 0 else {
            throw GetCreatorDetailUseCaseError.invalidRequest
        }
        
        do {
            // クリエイター詳細を取得
            let creator = try await creatorRepository.getCreatorById(id: request.creatorId)
            
            // 類似クリエイターを取得
            let similarCreators = try await creatorRepository.getSimilarCreators(
                creatorId: request.creatorId,
                limit: request.similarCreatorsLimit
            )
            
            return GetCreatorDetailUseCaseResponse(
                creator: creator,
                similarCreators: similarCreators
            )
            
        } catch CreatorRepositoryError.creatorNotFound {
            throw GetCreatorDetailUseCaseError.creatorNotFound
        } catch {
            throw GetCreatorDetailUseCaseError.repositoryError(error)
        }
    }
}
