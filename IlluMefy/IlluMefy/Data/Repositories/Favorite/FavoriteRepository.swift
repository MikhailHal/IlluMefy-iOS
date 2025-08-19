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
    
    init(apiClient: ApiClientProtocol = DependencyContainer.shared.container.resolve(ApiClientProtocol.self)!) {
        self.apiClient = apiClient
    }
    
    func getFavoriteCreator() async throws -> GetFavoriteCreatorListResponse {
        let response: GetFavoriteCreatorListResponse = try await apiClient.request(
            endpoint: "/users/favorite-creator-list",
            method: .get,
            parameters: nil,
            responseType: GetFavoriteCreatorListResponse.self,
            isRequiredAuth: true
        )
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
    }
    
    func removeFavoriteCreator(creatorId: String) async throws {
        let _: EmptyResponse = try await apiClient.request(
            endpoint: "/users/favorites/\(creatorId)",
            method: .delete,
            parameters: nil,
            responseType: EmptyResponse.self,
            isRequiredAuth: true
        )
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
