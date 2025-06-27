//
//  FavoriteRepository.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/24.
//

import Foundation

/// お気に入りリポジトリの実装
final class FavoriteRepository: FavoriteRepositoryProtocol {
    private let userDefaults: UserDefaults
    private let favoritesKey: String
    
    init(userDefaults: UserDefaults = UserDefaults.standard, favoritesKey: String = "IlluMefy_FavoriteCreatorIds") {
        self.userDefaults = userDefaults
        self.favoritesKey = favoritesKey
    }
    
    func getFavoriteCreatorIds() async throws -> [String] {
        let stored = userDefaults.stringArray(forKey: favoritesKey) ?? []
        // モック用に既存データがない場合のみデフォルトのお気に入りを追加
        if stored.isEmpty {
            let mockFavorites = ["creator_001", "creator_004", "creator_007"]
            userDefaults.set(mockFavorites, forKey: favoritesKey)
            return mockFavorites
        }
        return stored
    }
    
    func addFavoriteCreator(creatorId: String) async throws {
        var favorites = try await getFavoriteCreatorIds()
        if !favorites.contains(creatorId) {
            favorites.insert(creatorId, at: 0) // 新しいものを先頭に
            userDefaults.set(favorites, forKey: favoritesKey)
        }
    }
    
    func removeFavoriteCreator(creatorId: String) async throws {
        var favorites = try await getFavoriteCreatorIds()
        favorites.removeAll { $0 == creatorId }
        userDefaults.set(favorites, forKey: favoritesKey)
    }
    
    func isFavorite(creatorId: String) async throws -> Bool {
        let favorites = try await getFavoriteCreatorIds()
        return favorites.contains(creatorId)
    }
}