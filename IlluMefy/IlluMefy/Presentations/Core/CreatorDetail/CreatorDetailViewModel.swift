//
//  CreatorDetailViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

@MainActor
@Observable
final class CreatorDetailViewModel: CreatorDetailViewModelProtocol {
    var state: CreatorDetailViewState = .idle
    var isFavorite: Bool = false
    private let creator: Creator
    private let getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol

    init(
        creator: Creator,
        getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol,
        favoriteRepository: FavoriteRepositoryProtocol
    ) {
        self.creator = creator
        self.getCreatorDetailUseCase = getCreatorDetailUseCase
        self.favoriteRepository = favoriteRepository
        self.state = .loaded(creator: creator, similarCreators: [creator])
    }
    
    func toggleFavorite() {
        Task {
            do {
                // 成功したらUIを更新
                isFavorite.toggle()
                if isFavorite {
                    try await favoriteRepository.removeFavoriteCreator(creatorId: creator.id)
                } else {
                    try await favoriteRepository.addFavoriteCreator(creatorId: creator.id)
                }
            } catch {
                // エラーが発生した場合は変更を戻す
                print("Failed to toggle favorite: \(error)")
            }
        }
    }
}
