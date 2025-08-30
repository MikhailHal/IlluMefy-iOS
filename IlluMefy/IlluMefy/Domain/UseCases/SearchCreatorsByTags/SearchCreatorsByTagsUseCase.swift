//
//  SearchCreatorsByTagsUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/**
 タグによるクリエイター検索ユースケース
 
 指定されたタグに関連するクリエイターを検索します。
 */
final class SearchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol {
    
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(creatorRepository: CreatorRepositoryProtocol) {
        self.creatorRepository = creatorRepository
    }
    
    func execute(request: SearchCreatorsByTagsUseCaseRequest) async throws -> SearchCreatorsByTagsUseCaseResponse {
        // バリデーション
        guard !request.tagIds.isEmpty else {
            throw SearchCreatorsByTagsUseCaseError.emptyTags
        }
        
        guard request.tagIds.count <= 10 else {
            throw SearchCreatorsByTagsUseCaseError.tooManyTags
        }
        
        do {
            // 新しい拡張版のリポジトリメソッドを使用
            let result = try await creatorRepository.searchByTags(
                tagIds: request.tagIds,
                searchMode: request.searchMode,
                sortOrder: request.sortOrder,
                offset: request.offset,
                limit: request.limit
            )
            
            return SearchCreatorsByTagsUseCaseResponse(
                creators: result.creators,
                searchedTags: request.tagIds,
                totalCount: result.totalCount,
                hasMore: result.hasMore
            )
        } catch let error as CreatorRepositoryError {
            throw SearchCreatorsByTagsUseCaseError.repositoryError(error)
        } catch {
            throw SearchCreatorsByTagsUseCaseError.unknown(error)
        }
    }
}
