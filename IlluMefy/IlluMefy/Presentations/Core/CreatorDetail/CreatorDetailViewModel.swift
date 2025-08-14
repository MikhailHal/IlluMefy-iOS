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
    private let creatorId: String
    private let getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol
    private let favoriteRepository: FavoriteRepositoryProtocol

    init(
        creatorId: String,
        getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol,
        favoriteRepository: FavoriteRepositoryProtocol
    ) {
        self.creatorId = creatorId
        self.getCreatorDetailUseCase = getCreatorDetailUseCase
        self.favoriteRepository = favoriteRepository
    }
    
    func loadCreatorDetail() async {
        state = .loading
        
        do {
            let request = GetCreatorDetailUseCaseRequest(creatorId: creatorId)
            let response = try await getCreatorDetailUseCase.execute(request: request)
            
            // お気に入り状態を確認
            isFavorite = try await favoriteRepository.isFavorite(creatorId: creatorId)
            
            state = .loaded(creator: response.creator, similarCreators: response.similarCreators)
        } catch GetCreatorDetailUseCaseError.creatorNotFound {
            state = .error(title: "クリエイターが見つかりません", message: "指定されたクリエイターは存在しないか、削除された可能性があります。")
        } catch {
            state = .error(title: "読み込みエラー", message: "クリエイター情報の読み込みに失敗しました。もう一度お試しください。")
        }
    }
    
    func toggleFavorite() {
        Task {
            do {
                if isFavorite {
                    try await favoriteRepository.removeFavoriteCreator(creatorId: creatorId)
                } else {
                    try await favoriteRepository.addFavoriteCreator(creatorId: creatorId)
                }
                // 成功したらUIを更新
                isFavorite.toggle()
            } catch {
                // エラーが発生した場合は変更を戻す
                print("Failed to toggle favorite: \(error)")
            }
        }
    }
}
