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
    
    init(
        favoriteRepository: FavoriteRepositoryProtocol,
    ) {
        self.favoriteRepository = favoriteRepository
    }
    
    func execute() async throws -> [Creator] {
        let dataModels = try await favoriteRepository.getFavoriteCreator()
        return dataModels.data.map { $0.toCreator() }
    }
}
