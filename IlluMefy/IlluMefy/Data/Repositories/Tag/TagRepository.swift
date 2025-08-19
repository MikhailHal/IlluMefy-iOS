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
    
    // MARK: - Cache Properties
    
    private var popularTagsCache: GetPopularTagsResponse?
    private var popularTagsCacheTimestamp: Date?
    private let cacheValidDuration: TimeInterval = 600 // 10分
    
    // タグID毎キャッシュ
    private var tagCache: [String: TagDataModel] = [:] // tagId -> TagDataModel
    private var tagCacheTimestamp: [String: Date] = [:] // tagId -> timestamp
    private let tagCacheValidDuration: TimeInterval = 86400 // 24時間
    
    // MARK: - Initialization
    
    init(apiClient: ApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    // MARK: - Cache Helper
    
    private var isPopularTagsCacheValid: Bool {
        guard let timestamp = popularTagsCacheTimestamp else { return false }
        return Date().timeIntervalSince(timestamp) < cacheValidDuration
    }
    
    private func isCachedTagValid(for tagId: String) -> Bool {
        guard let timestamp = tagCacheTimestamp[tagId] else { return false }
        return Date().timeIntervalSince(timestamp) < tagCacheValidDuration
    }
    
    private func getCachedTags(for tagIds: [String]) -> [String: TagDataModel] {
        var cachedTags: [String: TagDataModel] = [:]
        for tagId in tagIds {
            if isCachedTagValid(for: tagId), let tag = tagCache[tagId] {
                cachedTags[tagId] = tag
            }
        }
        return cachedTags
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
        if isPopularTagsCacheValid, let cachedResponse = popularTagsCache {
            return cachedResponse
        }
        
        let response = try await apiClient.request(
            endpoint: "/tags/popular",
            method: .get,
            parameters: ["limit": limit],
            responseType: GetPopularTagsResponse.self,
            isRequiredAuth: false
        )
        
        popularTagsCache = response
        popularTagsCacheTimestamp = Date()
        return response
    }
    
    func getTagListByIdList(tagIdList: [String]) async throws -> GetTagListByIdListResponse {
        let validCachedTags = getCachedTags(for: tagIdList)
        let missingTagIds = tagIdList.filter { !validCachedTags.keys.contains($0) }
        
        // 全てキャッシュ済み
        if missingTagIds.isEmpty {
            let tags = tagIdList.compactMap { validCachedTags[$0] }
            return GetTagListByIdListResponse(data: tags)
        }
        
        // 不足分をAPIから取得
        let response = try await apiClient.request(
            endpoint: "/tags/by-ids",
            method: .post,
            parameters: ["tagIds": missingTagIds],
            responseType: GetTagListByIdListResponse.self,
            isRequiredAuth: false
        )
        
        // 新規タグをキャッシュに保存
        let now = Date()
        for tag in response.data {
            tagCache[tag.id] = tag
            tagCacheTimestamp[tag.id] = now
        }
        
        // 元のtagIdListの順序を保持して結合
        let orderedTags = tagIdList.compactMap { tagId -> TagDataModel? in
            if let cachedTag = validCachedTags[tagId] {
                return cachedTag
            }
            return response.data.first { $0.id == tagId }
        }
        
        return GetTagListByIdListResponse(data: orderedTags)
    }
}
