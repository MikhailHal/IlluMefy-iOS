//
//  FavoriteRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/24.
//

import Foundation

/// お気に入りリポジトリの実装
final class FavoriteRepository: FavoriteRepositoryProtocol {
    private let apiClient: ApiClientProtocol
    private var cache: GetFavoriteCreatorListResponse?
    private var cacheTimestamp: Date?
    private let cacheValidDuration: TimeInterval = 300 // 5分
    
    init(apiClient: ApiClientProtocol = DependencyContainer.shared.container.resolve(ApiClientProtocol.self)!) {
        self.apiClient = apiClient
    }
    
    private var isCacheValid: Bool {
        guard let timestamp = cacheTimestamp else { return false }
        return Date().timeIntervalSince(timestamp) < cacheValidDuration
    }
    
    func getFavoriteCreator() async throws -> GetFavoriteCreatorListResponse {
        if isCacheValid, let cachedResponse = cache {
            return cachedResponse
        }
        let response: GetFavoriteCreatorListResponse = try await apiClient.request(
            endpoint: "/users/favorite-creator-list",
            method: .get,
            parameters: nil,
            responseType: GetFavoriteCreatorListResponse.self,
            isRequiredAuth: true
        )
        cache = response
        cacheTimestamp = Date()
        return response
    }
    
    func addFavoriteCreator(creatorId: String) async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "/users/favorites/\(creatorId)",
            method: .post,
            parameters: nil,
            responseType: EmptyResponse.self,
            isRequiredAuth: true
        )
        self.cacheTimestamp = nil
    }
    
    func removeFavoriteCreator(creatorId: String) async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "/users/favorites/\(creatorId)",
            method: .delete,
            parameters: nil,
            responseType: EmptyResponse.self,
            isRequiredAuth: true
        )
        self.cacheTimestamp = nil
    }
    
    func isFavorite(creatorId: String) async throws -> Bool {        
        let response: IsFavoriteResponse = try await apiClient.request(
            endpoint: "/users/favorites/\(creatorId)/check",
            method: .get,
            parameters: nil,
            responseType: IsFavoriteResponse.self,
            isRequiredAuth: true
        )
        return response.data.isFavorite
    }
}
