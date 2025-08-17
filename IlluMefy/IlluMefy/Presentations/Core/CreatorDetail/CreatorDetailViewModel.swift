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
    var isLoadingTags = true
    var isLoadingFavoriteStauts = true
    var isFavorite = false
    var errorMessage: String?
    
    // 依存関係
    private let getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol
    private let getTagListByTagIdListUseCase: GetTagListByTagIdListUseCaseProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol
    private let toggleFavoriteCreatorUseCase: ToggleFavoriteCreatorUseCaseProtocol

    init(
        creator: Creator,
        getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol,
        getTagListByTagIdListUseCase: GetTagListByTagIdListUseCaseProtocol,
        favoriteRepository: FavoriteRepositoryProtocol,
        toggleFavoriteCreatorUseCase: ToggleFavoriteCreatorUseCaseProtocol
    ) {
        self.creator = creator
        self.getCreatorDetailUseCase = getCreatorDetailUseCase
        self.getTagListByTagIdListUseCase = getTagListByTagIdListUseCase
        self.favoriteRepository = favoriteRepository
        self.toggleFavoriteCreatorUseCase = toggleFavoriteCreatorUseCase
        
        Task {
            await loadTags()
            await checkFavoriteStatus()
        }
    }
    
    func loadTags() async {
        isLoadingTags = true
        errorMessage = nil
        
        do {
            // クリエイターのタグIDリストが空の場合は早期リターン
            guard !creator.tag.isEmpty else {
                tags = []
                isLoadingTags = false
                return
            }
            
            // GetTagListByTagIdListUseCaseを使用してタグ情報を取得
            let request = GetTagListByTagIdListUseCaseRequest(tagIdList: creator.tag)
            let response = try await getTagListByTagIdListUseCase.execute(request: request)
            
            tags = response.tags
            isLoadingTags = false
        } catch {
            errorMessage = "タグの読み込みに失敗しました"
            isLoadingTags = false
        }
    }
    
    private func checkFavoriteStatus() async {
        do {
            isLoadingFavoriteStauts = true
            isFavorite = try await favoriteRepository.isFavorite(creatorId: creator.id)
            isLoadingFavoriteStauts = false
        } catch {
            // エラーの場合はfalseとして扱う
            isFavorite = false
            isLoadingFavoriteStauts = false
        }
    }
    
    func toggleFavorite() {
        Task {
            do {
                let request = ToggleFavoriteCreatorUseCaseRequest(
                    creatorId: creator.id,
                    shouldAddToFavorites: !isFavorite
                )
                let response = try await toggleFavoriteCreatorUseCase.execute(request: request)
                isFavorite = response.isNowFavorite
            } catch {
                errorMessage = "お気に入りの更新に失敗しました"
            }
        }
    }
}
