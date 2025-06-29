//
//  FavoriteViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/24.
//

import Foundation
import Combine

/// お気に入り画面のViewModel
@MainActor
final class FavoriteViewModel: FavoriteViewModelProtocol {
    // MARK: - Published Properties
    @Published private(set) var favoriteCreators: [Creator] = []
    @Published private(set) var isLoading = false
    @Published var selectedTab: FavoriteTabType = .favorites
    
    // MARK: - Private Properties
    private let getFavoriteCreatorsUseCase: GetFavoriteCreatorsUseCaseProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    
    // MARK: - Initialization
    init(
        getFavoriteCreatorsUseCase: GetFavoriteCreatorsUseCaseProtocol,
        favoriteRepository: FavoriteRepositoryProtocol
    ) {
        self.getFavoriteCreatorsUseCase = getFavoriteCreatorsUseCase
        self.favoriteRepository = favoriteRepository
    }
    
    // MARK: - Public Methods
    func loadFavoriteCreators() async {
        isLoading = true
        
        do {
            let creators = try await getFavoriteCreatorsUseCase.execute()
            favoriteCreators = creators
        } catch {
            print("Failed to load favorite creators: \(error)")
            favoriteCreators = []
        }
        
        isLoading = false
    }
    
    func removeFavorite(creatorId: String) async {
        do {
            try await favoriteRepository.removeFavoriteCreator(creatorId: creatorId)
            // リストから削除
            favoriteCreators.removeAll { $0.id == creatorId }
        } catch {
            print("Failed to remove favorite: \(error)")
        }
    }
    
    func selectTab(_ tab: FavoriteTabType) {
        selectedTab = tab
        // タブ切り替え時に対応するデータを読み込み
        Task {
            switch tab {
            case .favorites:
                await loadFavoriteCreators()
            case .history:
                // 履歴は後回しなので一旦空にする
                favoriteCreators = []
            }
        }
    }
}