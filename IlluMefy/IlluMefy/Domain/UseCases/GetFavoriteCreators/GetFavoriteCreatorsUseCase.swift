//
//  GetFavoriteCreatorsUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/24.
//

import Foundation

/// お気に入りクリエイター取得ユースケース
final class GetFavoriteCreatorsUseCase: GetFavoriteCreatorsUseCaseProtocol {
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(
        favoriteRepository: FavoriteRepositoryProtocol,
        creatorRepository: CreatorRepositoryProtocol
    ) {
        self.favoriteRepository = favoriteRepository
        self.creatorRepository = creatorRepository
    }
    
    func execute() async throws -> [Creator] {
        let favoriteIds = try await favoriteRepository.getFavoriteCreatorIds()
        
        // 各IDに対してクリエイター情報を取得
        var creators: [Creator] = []
        for id in favoriteIds {
            do {
                let creator = try await creatorRepository.getCreatorById(id: id)
                creators.append(creator)
            } catch {
                // 取得できなかったクリエイターはスキップ
                print("Failed to fetch creator with id: \(id)")
            }
        }
        
        return creators
    }
}