//
//  MockSearchTagsByNameRepository.swift
//  IlluMefyTests
//
//  Created by Assistant on 2025/06/16.
//

import Foundation
@testable import IlluMefy

@MainActor
class MockSearchTagsByNameRepository: TagRepositoryProtocol {
    var searchByNameResult: Result<TagSearchResult, TagRepositoryError>?
    var lastSearchByNameParams: (andQuery: String, orQuery: String, offset: Int, limit: Int)?
    
    func searchByName(andQuery: String, orQuery: String, offset: Int, limit: Int) async throws -> TagSearchResult {
        lastSearchByNameParams = (andQuery: andQuery, orQuery: orQuery, offset: offset, limit: limit)
        
        guard let result = searchByNameResult else {
            throw TagRepositoryError.networkError
        }
        
        switch result {
        case .success(let response):
            return response
        case .failure(let error):
            throw error
        }
    }
    
    func getAllTags() async throws -> [Tag] {
        throw TagRepositoryError.networkError
    }
    
    func getPopularTags(limit: Int) async throws -> GetPopularTagsResponse {
        throw TagRepositoryError.networkError
    }
}