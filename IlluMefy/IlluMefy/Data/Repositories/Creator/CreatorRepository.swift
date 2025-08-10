//
//  CreatorRepository.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/10.
//

import Foundation

/**
 クリエイターリポジトリの実装
 
 バックエンドAPIと通信してクリエイター情報を取得する実装です。
 */
final class CreatorRepository: CreatorRepositoryProtocol {
    
    // MARK: - Dependencies
    
    private let apiClient: ApiClientProtocol
    
    // MARK: - Initialization
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - CreatorRepositoryProtocol
    
    func getAllCreators() async throws -> [Creator] {
        // TODO: 実装予定
        throw CreatorRepositoryError.notImplemented
    }
    
    func getCreatorsUpdatedAfter(date: Date) async throws -> [Creator] {
        // TODO: 実装予定
        throw CreatorRepositoryError.notImplemented
    }
    
    func searchCreatorsByTags(tagIds: [String]) async throws -> [Creator] {
        // TODO: 実装予定
        throw CreatorRepositoryError.notImplemented
    }
    
    func getPopularCreators(limit: Int) async throws -> GetPopularCreatorsResponse {
        return try await apiClient.request(
            endpoint: "/creators/popular",
            method: .get,
            parameters: ["limit": limit],
            responseType: GetPopularCreatorsResponse.self,
            isRequiredAuth: false
        )
    }
    
    func getCreatorById(id: String) async throws -> Creator {
        // TODO: 実装予定
        throw CreatorRepositoryError.notImplemented
    }
    
    func getSimilarCreators(creatorId: String, limit: Int) async throws -> [Creator] {
        // TODO: 実装予定
        throw CreatorRepositoryError.notImplemented
    }
    
    func searchByName(
        query: String,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult {
        // TODO: 実装予定
        throw CreatorRepositoryError.notImplemented
    }
    
    func searchByTags(
        tagIds: [String],
        searchMode: TagSearchMode,
        sortOrder: CreatorSortOrder,
        offset: Int,
        limit: Int
    ) async throws -> CreatorSearchResult {
        // TODO: 実装予定
        throw CreatorRepositoryError.notImplemented
    }
}
