//
//  HomeViewModel.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/10.
//

import Foundation
import Combine

@MainActor
final class HomeViewModel: HomeViewModelProtocol {
    
    // MARK: - Published Properties
    @Published private(set) var popularTags: [Tag] = []
    @Published private(set) var popularCreators: [Creator] = []
    @Published private(set) var recommendedCreators: [Creator] = []
    @Published private(set) var newArrivalCreators: [Creator] = []
    @Published private(set) var isLoading = false
    @Published private(set) var error: Error?
    
    // MARK: - Use Cases
    private let getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol
    private let searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol
    private let getOperatorMessageUseCase: GetOperatorMessageUseCaseProtocol
    
    // MARK: - Initialization
    init(
        getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol,
        searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol,
        getOperatorMessageUseCase: GetOperatorMessageUseCaseProtocol
    ) {
        self.getPopularCreatorsUseCase = getPopularCreatorsUseCase
        self.searchCreatorsByTagsUseCase = searchCreatorsByTagsUseCase
        self.getOperatorMessageUseCase = getOperatorMessageUseCase
    }
    
    // MARK: - Public Methods
    func onAppear() {
        Task {
            await loadInitialData()
        }
    }
    
    func loadInitialData() async {
        await withErrorHandling {
            await _ = (loadPopularCreators(), loadPopularTags(), loadRecommendedCreators(), loadNewArrivalCreators(), loadOperatorMessage())
        }
    }
    
    func refreshData() async {
        await loadInitialData()
    }
    
    func getPopularTagList() -> [Tag] {
        return popularTags
    }
    
    func getPopularCreatorList() -> [Creator] {
        return popularCreators
    }
    
    func getRecommendedCreatorList() -> [Creator] {
        return recommendedCreators
    }
    
    func getNewArrivalsCreatorList() -> [Creator] {
        return newArrivalCreators
    }
    
    // MARK: - Private Methods
    private func loadPopularCreators() async {
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        let response = try? await getPopularCreatorsUseCase.execute(request: request)
        popularCreators = response?.creators ?? []
    }
    
    private func loadPopularTags() async {
        // Note: Implement when tag use case is available
        // For now, using mock data
        popularTags = createMockTags()
    }
    
    private func createMockTags() -> [Tag] {
        return [
            createTag(id: "1", display: "FPS", name: "fps", count: 1250),
            createTag(id: "2", display: "VTuber", name: "vtuber", count: 890),
            createTag(id: "3", display: "Minecraft", name: "minecraft", count: 720),
            createTag(id: "4", display: "APEX", name: "apex-legends", count: 650),
            createTag(id: "5", display: "Valorant", name: "valorant", count: 580),
            createTag(id: "6", display: "歌ってみた", name: "singing", count: 420),
            createTag(id: "7", display: "踊ってみた", name: "dance", count: 380),
            createTag(id: "8", display: "プロゲーマー", name: "professional", count: 320),
            createTag(id: "9", display: "レトロゲーム", name: "retro", count: 280)
        ]
    }
    
    private func createTag(id: String, display: String, name: String, count: Int) -> Tag {
        return Tag(
            id: id,
            displayName: display,
            tagName: name,
            clickedCount: count,
            createdAt: Date(),
            updatedAt: Date(),
            parentTagId: nil,
            childTagIds: []
        )
    }
    
    private func loadRecommendedCreators() async {
        // Note: Implement recommendation logic
        // For now, reusing popular creators logic
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        let response = try? await getPopularCreatorsUseCase.execute(request: request)
        recommendedCreators = response?.creators ?? []
    }
    
    private func loadNewArrivalCreators() async {
        // Note: Implement new arrivals logic
        // For now, reusing popular creators logic
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        let response = try? await getPopularCreatorsUseCase.execute(request: request)
        newArrivalCreators = response?.creators ?? []
    }
    
    private func loadOperatorMessage() async {
        // 運営メッセージをサーバーから取得してキャッシュに保存
        // エラーが発生してもアプリの動作には影響しないようにする
        do {
            _ = try await getOperatorMessageUseCase.fetchAndCacheOperatorMessage()
        } catch {
            // ログ出力（本番環境では適切なログシステムに送信）
            print("Failed to load operator message: \(error)")
        }
    }
    
    private func withErrorHandling(_ operation: () async throws -> Void) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await operation()
            error = nil
        } catch {
            self.error = error
        }
    }
}
