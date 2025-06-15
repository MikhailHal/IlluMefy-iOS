//
//  SearchCreatorsByNameUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でクリエイターを検索するUseCase
final class SearchCreatorsByNameUseCase: SearchCreatorsByNameUseCaseProtocol {
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(creatorRepository: CreatorRepositoryProtocol) {
        self.creatorRepository = creatorRepository
    }
    
    func execute(request: SearchCreatorsByNameUseCaseRequest) async throws -> SearchCreatorsByNameUseCaseResponse {
        // 入力値バリデーション
        guard !request.query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw SearchCreatorsByNameUseCaseError.emptyQuery
        }
        
        guard request.query.count <= 100 else {
            throw SearchCreatorsByNameUseCaseError.invalidQuery
        }
        
        do {
            // リポジトリから検索実行
            let result = try await creatorRepository.searchByName(
                query: request.query.trimmingCharacters(in: .whitespacesAndNewlines),
                sortOrder: request.sortOrder,
                offset: request.offset,
                limit: request.limit
            )
            
            return SearchCreatorsByNameUseCaseResponse(
                creators: result.creators,
                totalCount: result.totalCount,
                hasMore: result.hasMore
            )
        } catch let error as CreatorRepositoryError {
            throw SearchCreatorsByNameUseCaseError.repositoryError(error)
        } catch {
            throw SearchCreatorsByNameUseCaseError.unknownError
        }
    }
}