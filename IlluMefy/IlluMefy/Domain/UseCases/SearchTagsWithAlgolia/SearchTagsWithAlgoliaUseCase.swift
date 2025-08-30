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
    
    func execute(request: SearchTagsWithAlgoliaUseCaseRequest) async throws -> [Tag] {
        let searchResponse = try await algoliaRepository.searchTags(
            query: request.query,
            limit: request.limit
        )
        
        return searchResponse.tags.map { tagItem in
            Tag(
                id: tagItem.objectID.rawValue,
                displayName: tagItem.name,
                tagName: tagItem.name,
                clickedCount: tagItem.viewCount ?? 0,
                createdAt: Date(),
                updatedAt: Date()
            )
        }
    }
}
