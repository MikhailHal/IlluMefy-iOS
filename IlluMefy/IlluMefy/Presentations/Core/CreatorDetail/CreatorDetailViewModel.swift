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
    private let getTagListByTagIdListUseCase: GetTagListByTagIdListUseCaseProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol

    init(
        creator: Creator,
        getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol,
        getTagListByTagIdListUseCase: GetTagListByTagIdListUseCaseProtocol,
        favoriteRepository: FavoriteRepositoryProtocol
    ) {
        self.creator = creator
        self.getCreatorDetailUseCase = getCreatorDetailUseCase
        self.getTagListByTagIdListUseCase = getTagListByTagIdListUseCase
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
