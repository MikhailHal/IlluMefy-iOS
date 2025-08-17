//
//  CheckAlreadyFavoriteCreatorUseCase.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/17.
//

import Foundation

final class CheckAlreadyFavoriteCreatorUseCase: CheckAlreadyFavoriteCreatorUseCaseProtocol {
    private let favoriteRepository: FavoriteRepositoryProtocol
    
    init(favoriteRepository: FavoriteRepositoryProtocol) {
        self.favoriteRepository = favoriteRepository
    }
    
    func execute(request: CheckAlreadyFavoriteCreatorUseCaseRequest) async throws -> CheckAlreadyFavoriteCreatorUseCaseResponse {
        guard !request.creatorId.isEmpty else {
            throw CheckAlreadyFavoriteCreatorUseCaseError.invalidCreatorId
        }
        
        do {
            let isFavorite = try await favoriteRepository.isFavorite(creatorId: request.creatorId)
            return CheckAlreadyFavoriteCreatorUseCaseResponse(isFavorite: isFavorite)
        } catch {
            if error is RepositoryErrorProtocol {
                throw CheckAlreadyFavoriteCreatorUseCaseError.repositoryError(error)
            } else {
                throw CheckAlreadyFavoriteCreatorUseCaseError.unexpectedError(error)
            }
        }
    }
}