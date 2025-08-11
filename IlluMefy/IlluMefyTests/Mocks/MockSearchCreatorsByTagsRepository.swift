//
//  MockSearchCreatorsByTagsRepository.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Foundation
@testable import IlluMefy

@MainActor
class MockSearchCreatorsByTagsRepository: CreatorRepositoryProtocol {
    var searchByTagsResult: Result<CreatorSearchResult, CreatorRepositoryError>?
    var lastSearchByTagsParams: (tagIds: [String], searchMode: TagSearchMode, sortOrder: CreatorSortOrder, offset: Int, limit: Int)?
    
    func getAllCreators() async throws -> [Creator] {
        throw CreatorRepositoryError.networkError
    }
    
    func getCreatorsUpdatedAfter(date: Date) async throws -> [Creator] {
        throw CreatorRepositoryError.networkError
    }
    
    func searchCreatorsByTags(tagIds: [String]) async throws -> [Creator] {
        throw CreatorRepositoryError.networkError
    }
    
    func getPopularCreators(limit: Int) async throws -> GetPopularCreatorsResponse {
        throw CreatorRepositoryError.networkError
    }
    
    func getCreatorById(id: String) async throws -> Creator {
        throw CreatorRepositoryError.creatorNotFound
    }
    
    func getSimilarCreators(creatorId: String, limit: Int) async throws -> [Creator] {
        throw CreatorRepositoryError.networkError
    }
    
    func searchByName(query: String, sortOrder: CreatorSortOrder, offset: Int, limit: Int) async throws -> CreatorSearchResult {
        throw CreatorRepositoryError.networkError
    }
    
    func searchByTags(tagIds: [String], searchMode: TagSearchMode, sortOrder: CreatorSortOrder, offset: Int, limit: Int) async throws -> CreatorSearchResult {
        lastSearchByTagsParams = (tagIds: tagIds, searchMode: searchMode, sortOrder: sortOrder, offset: offset, limit: limit)
        
        guard let result = searchByTagsResult else {
            throw CreatorRepositoryError.networkError
        }
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
}
