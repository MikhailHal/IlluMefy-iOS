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
    // 表示データ
    let creator: Creator
    var tags: [Tag] = []
    var similarCreators: [Creator] = []
    
    // 状態フラグ
    var isLoadingTags = false
    var isFavorite = false
    var errorMessage: String?
    
    // 依存関係
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
        
        Task {
            await loadTags()
            await checkFavoriteStatus()
        }
    }
    
    func loadTags() async {
        isLoadingTags = true
        errorMessage = nil
        
        do {
            // TODO: 実際のタグ取得処理を実装
            // 一旦モックデータを返す
            try await Task.sleep(nanoseconds: 500_000_000) // 0.5秒の遅延
            
            tags = [
                Tag(
                    id: "tag_001",
                    displayName: "ゲーム",
                    tagName: "game",
                    clickedCount: 1500,
                    createdAt: Date(),
                    updatedAt: Date()
                ),
                Tag(
                    id: "tag_007",
                    displayName: "FPS",
                    tagName: "fps",
                    clickedCount: 500,
                    createdAt: Date(),
                    updatedAt: Date()
                )
            ]
            isLoadingTags = false
        } catch {
            errorMessage = "タグの読み込みに失敗しました"
            isLoadingTags = false
        }
    }
    
    private func checkFavoriteStatus() async {
        do {
            isFavorite = try await favoriteRepository.isFavorite(creatorId: creator.id)
        } catch {
            // エラーの場合はfalseとして扱う
            isFavorite = false
        }
    }
    
    func toggleFavorite() {
        Task {
            do {
                if isFavorite {
                    try await favoriteRepository.removeFavoriteCreator(creatorId: creator.id)
                    isFavorite = false
                } else {
                    try await favoriteRepository.addFavoriteCreator(creatorId: creator.id)
                    isFavorite = true
                }
            } catch {
                errorMessage = "お気に入りの更新に失敗しました"
            }
        }
    }
}
