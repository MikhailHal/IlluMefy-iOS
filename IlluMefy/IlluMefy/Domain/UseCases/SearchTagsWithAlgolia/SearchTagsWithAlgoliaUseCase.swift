//
//  SearchTagsWithAlgoliaUseCase.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation

/// Algoliaタグ検索UseCase
final class SearchTagsWithAlgoliaUseCase: SearchTagsWithAlgoliaUseCaseProtocol {
    private let algoliaRepository: AlgoliaRepositoryProtocol
    
    init(algoliaRepository: AlgoliaRepositoryProtocol) {
        self.algoliaRepository = algoliaRepository
    }
    
    func execute(request: SearchTagsWithAlgoliaUseCaseRequest) async throws -> SearchTagsWithAlgoliaUseCaseResponse {
        let searchResponse = try await algoliaRepository.searchTags(
            query: request.query,
            limit: request.limit
        )
        
        // SearchTagItemからTagに変換してからTagSuggestionに変換
        let suggestions = searchResponse.tags.map { tagItem in
            let tag = Tag(
                id: tagItem.objectID.rawValue,
                displayName: tagItem.name,
                tagName: tagItem.name,
                clickedCount: tagItem.viewCount ?? 0,
                createdAt: Date(),
                updatedAt: Date()
            )
            return TagSuggestion(tag: tag)
        }
        
        return SearchTagsWithAlgoliaUseCaseResponse(
            suggestions: suggestions,
            totalCount: searchResponse.totalCount
        )
    }
}