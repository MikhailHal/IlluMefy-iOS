//
//  MockCreatorDetailViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// CreatorDetail画面のプレビュー用モックViewModel
@MainActor
@Observable
final class MockCreatorDetailViewModel: CreatorDetailViewModelProtocol {
    
    // 表示データ
    var creator: Creator
    var tags: [Tag] = []
    var similarCreators: [Creator] = []
    
    // 状態フラグ
    var isLoadingTags = false
    var isFavorite = false
    var errorMessage: String?
    
    init(
        creator: Creator = MockCreatorDetailData.sampleCreator,
        similarCreators: [Creator] = MockCreatorDetailData.similarCreators
    ) {
        self.creator = creator
        self.similarCreators = similarCreators
        
        // 初期化時にタグを読み込む
        Task {
            await loadTags()
        }
    }
    
    func loadTags() async {
        isLoadingTags = true
        errorMessage = nil
        
        // シミュレート遅延
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒
        
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
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
    }
    
    // エラー状態のモック
    static func mockError() -> MockCreatorDetailViewModel {
        let viewModel = MockCreatorDetailViewModel()
        viewModel.errorMessage = "これはプレビュー用のエラー表示です"
        return viewModel
    }
}
