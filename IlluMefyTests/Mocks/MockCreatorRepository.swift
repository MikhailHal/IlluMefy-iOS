//
//  MockCreatorRepository.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
@testable import IlluMefy

final class MockCreatorRepository: CreatorRepositoryProtocol {
    
    // MARK: - Search by Name
    var searchByNameResult: Result<CreatorSearchResult, CreatorRepositoryError>?
    var lastSearchByNameCall: (query: String, sortOrder: CreatorSortOrder, offset: Int, limit: Int)?
    var searchByNameCallCount = 0
    
    func searchByName(
        query: String,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult {
        searchByNameCallCount += 1
        lastSearchByNameCall = (query, sortOrder, offset, limit)
        
        guard let result = searchByNameResult else {
            throw CreatorRepositoryError.networkError
        }
        
        switch result {
        case .success(let searchResult):
            return searchResult
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - Search by Tags
    var searchByTagsResult: Result<CreatorSearchResult, CreatorRepositoryError>?
    var lastSearchByTagsCall: (tagIds: [String], searchMode: TagSearchMode, sortOrder: CreatorSortOrder, offset: Int, limit: Int)?
    var searchByTagsCallCount = 0
    
    func searchByTags(
        tagIds: [String],
        searchMode: TagSearchMode,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult {
        searchByTagsCallCount += 1
        lastSearchByTagsCall = (tagIds, searchMode, sortOrder, offset, limit)
        
        guard let result = searchByTagsResult else {
            throw CreatorRepositoryError.networkError
        }
        
        switch result {
        case .success(let searchResult):
            return searchResult
        case .failure(let error):
            throw error
        }
    }
    
    // MARK: - 既存のメソッド（ダミー実装）
    
    func getAllCreators() async throws -> [Creator] {
        return []
    }
    
    func getCreatorsUpdatedAfter(date: Date) async throws -> [Creator] {
        return []
    }
    
    func searchCreatorsByTags(tagIds: [String]) async throws -> [Creator] {
        return []
    }
    
    func getPopularCreators(limit: Int) async throws -> [Creator] {
        return []
    }
    
    func getCreatorById(id: String) async throws -> Creator {
        throw CreatorRepositoryError.creatorNotFound
    }
    
    func getSimilarCreators(creatorId: String, limit: Int) async throws -> [Creator] {
        return []
    }
}