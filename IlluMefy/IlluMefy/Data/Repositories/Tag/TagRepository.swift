//
//  TagRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

/// タグリポジトリの実装
final class TagRepository: TagRepositoryProtocol {
    // MARK: - Dependencies
    
    private let apiClient: ApiClientProtocol
    
    // MARK: - Initialization
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - TagRepositoryProtocol
    
    func searchByName(
        andQuery: String,
        orQuery: String,
        offset: Int,
        limit: Int
    ) async throws -> TagSearchResult {
        // TODO: 実装予定
        throw TagRepositoryError.networkError
    }
    
    func getAllTags() async throws -> [Tag] {
        // TODO: 実装予定
        throw TagRepositoryError.networkError
    }
    
    func getPopularTags(limit: Int) async throws -> GetPopularTagsResponse {
        let response = try await apiClient.request(
            endpoint: "/tags/popular",
            method: .get,
            parameters: ["limit": limit],
            responseType: GetPopularTagsResponse.self,
            isRequiredAuth: false
        )
        
        return response
    }
    
    func getTagListByIdList(tagIdList: [String]) async throws -> GetTagListByIdListResponse {
        let response = try await apiClient.request(
            endpoint: "/tags/by-ids",
            method: .post,
            parameters: ["tagIds": tagIdList],
            responseType: GetTagListByIdListResponse.self,
            isRequiredAuth: false
        )
        
        return response
    }
}
