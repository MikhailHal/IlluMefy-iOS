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
    
    // MARK: - Cache Properties
    
    private var popularCreatorsCache: GetPopularCreatorsResponse?
    private var popularCreatorsCacheTimestamp: Date?
    private var newestCreatorsCache: GetNewestCreatorsResponse?
    private var newestCreatorsCacheTimestamp: Date?
    private let cacheValidDuration: TimeInterval = 600 // 10分
    
    // MARK: - Initialization
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Cache Helpers
    
    private var isPopularCreatorsCacheValid: Bool {
        guard let timestamp = popularCreatorsCacheTimestamp else { return false }
        return Date().timeIntervalSince(timestamp) < cacheValidDuration
    }
    
    private var isNewestCreatorsCacheValid: Bool {
        guard let timestamp = newestCreatorsCacheTimestamp else { return false }
        return Date().timeIntervalSince(timestamp) < cacheValidDuration
    }
    
    // MARK: - Cache Management
    
    func clearCache() {
        popularCreatorsCache = nil
        popularCreatorsCacheTimestamp = nil
        newestCreatorsCache = nil
        newestCreatorsCacheTimestamp = nil
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
        if isPopularCreatorsCacheValid, let cachedResponse = popularCreatorsCache {
            return cachedResponse
        }
        
        let response = try await apiClient.request(
            endpoint: "/creators/popular",
            method: .get,
            parameters: ["limit": limit],
            responseType: GetPopularCreatorsResponse.self,
            isRequiredAuth: false
        )
        
        popularCreatorsCache = response
        popularCreatorsCacheTimestamp = Date()
        return response
    }
    
    func getNewestCreators(limit: Int) async throws -> GetNewestCreatorsResponse {
        if isNewestCreatorsCacheValid, let cachedResponse = newestCreatorsCache {
            return cachedResponse
        }
        
        let response = try await apiClient.request(
            endpoint: "/creators/newest",
            method: .get,
            parameters: ["limit": limit],
            responseType: GetNewestCreatorsResponse.self,
            isRequiredAuth: false
        )
        
        newestCreatorsCache = response
        newestCreatorsCacheTimestamp = Date()
        return response
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
        let parameters: [String: Any] = [
            "q": tagIds.joined(separator: ","),
            "limit": limit
        ]
        
        let response = try await apiClient.request(
            endpoint: "/creators/search",
            method: .get,
            parameters: parameters,
            responseType: SearchCreatorsByTagsResponse.self,
            isRequiredAuth: false
        )
        
        return CreatorSearchResult(
            creators: response.data.map { $0.toCreator() },
            totalCount: response.data.count,
            hasMore: false // Backend doesn't support pagination yet
        )
    }
}
