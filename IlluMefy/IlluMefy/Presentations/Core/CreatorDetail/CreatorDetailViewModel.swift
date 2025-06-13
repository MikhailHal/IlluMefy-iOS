//
//  CreatorDetailViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

@MainActor
final class CreatorDetailViewModel: CreatorDetailViewModelProtocol {
    
    // MARK: - Published Properties
    @Published var state: CreatorDetailViewState = .idle
    @Published var isFavorite: Bool = false
    
    // MARK: - Private Properties
    private let creatorId: String
    private let getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol
    
    // MARK: - Initialization
    init(creatorId: String, getCreatorDetailUseCase: GetCreatorDetailUseCaseProtocol) {
        self.creatorId = creatorId
        self.getCreatorDetailUseCase = getCreatorDetailUseCase
    }
    
    // MARK: - CreatorDetailViewModelProtocol
    
    func loadCreatorDetail() async {
        state = .loading
        
        do {
            let request = GetCreatorDetailUseCaseRequest(creatorId: creatorId)
            let response = try await getCreatorDetailUseCase.execute(request: request)
            
            state = .loaded(creator: response.creator, similarCreators: response.similarCreators)
        } catch GetCreatorDetailUseCaseError.creatorNotFound {
            state = .error(title: "クリエイターが見つかりません", message: "指定されたクリエイターは存在しないか、削除された可能性があります。")
        } catch {
            state = .error(title: "読み込みエラー", message: "クリエイター情報の読み込みに失敗しました。もう一度お試しください。")
        }
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
        // Note: お気に入り機能の実装は今後追加予定
    }
}
