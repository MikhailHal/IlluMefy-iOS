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
    
    func getFavoriteCreatorIds() async throws -> [String] {
        struct FavoritesResponse: Codable {
            let data: [String]
        }
        
        let response: FavoritesResponse = try await apiClient.request(
            endpoint: "/users/favorites",
            method: .get,
            parameters: nil,
            responseType: FavoritesResponse.self,
            isRequiredAuth: true
        )
        return response.data
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
        print("")
    }
    
    func isFavorite(creatorId: String) async throws -> Bool {
        return true
    }
}
