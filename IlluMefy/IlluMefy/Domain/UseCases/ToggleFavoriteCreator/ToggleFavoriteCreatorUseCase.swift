//
//  ToggleFavoriteCreatorUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/17.
//

import Foundation

final class ToggleFavoriteCreatorUseCase: ToggleFavoriteCreatorUseCaseProtocol {
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let creatorRepository: CreatorRepositoryProtocol
    
    init(favoriteRepository: FavoriteRepositoryProtocol, creatorRepository: CreatorRepositoryProtocol) {
        self.favoriteRepository = favoriteRepository
        self.creatorRepository = creatorRepository
    }
    
    func execute(request: ToggleFavoriteCreatorUseCaseRequest) async throws -> ToggleFavoriteCreatorUseCaseResponse {
        guard !request.creatorId.isEmpty else {
            throw ToggleFavoriteCreatorUseCaseError.invalidCreatorId
        }
        
        do {
            if request.shouldAddToFavorites {
                try await favoriteRepository.addFavoriteCreator(creatorId: request.creatorId)
                creatorRepository.clearCache()
                return ToggleFavoriteCreatorUseCaseResponse(isNowFavorite: true)
            } else {
                try await favoriteRepository.removeFavoriteCreator(creatorId: request.creatorId)
                creatorRepository.clearCache()
                return ToggleFavoriteCreatorUseCaseResponse(isNowFavorite: false)
            }
        } catch {
            if error is RepositoryErrorProtocol {
                throw ToggleFavoriteCreatorUseCaseError.repositoryError(error)
            } else {
                throw ToggleFavoriteCreatorUseCaseError.unexpectedError(error)
            }
        }
    }
}