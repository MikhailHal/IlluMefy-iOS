//
//  MockCreatorDetailViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

/// CreatorDetail画面のプレビュー用モックViewModel
@MainActor
final class MockCreatorDetailViewModel: CreatorDetailViewModelProtocol {
    
    @Published var state: CreatorDetailViewState = .idle
    @Published var isFavorite: Bool = false
    
    private let mockCreator: Creator
    private let mockSimilarCreators: [Creator]
    
    init(
        creator: Creator = MockCreatorDetailData.sampleCreator,
        similarCreators: [Creator] = MockCreatorDetailData.similarCreators
    ) {
        self.mockCreator = creator
        self.mockSimilarCreators = similarCreators
    }
    
    func loadCreatorDetail() async {
        state = .loading
        
        // シミュレート遅延
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5秒
        
        state = .loaded(creator: mockCreator, similarCreators: mockSimilarCreators)
    }
    
    func toggleFavorite() {
        isFavorite.toggle()
    }
    
    // エラー状態のモック
    static func mockError() -> MockCreatorDetailViewModel {
        let viewModel = MockCreatorDetailViewModel()
        viewModel.state = .error(title: "テストエラー", message: "これはプレビュー用のエラー表示です")
        return viewModel
    }
}
