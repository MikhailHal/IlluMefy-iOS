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
    private let getNewestCreatorsUseCase: GetNewestCreatorsUseCaseProtocol
    
    // MARK: - Initialization
    init(
        getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol,
        searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol,
        getNewestCreatorsUseCase: GetNewestCreatorsUseCaseProtocol
    ) {
        self.getPopularCreatorsUseCase = getPopularCreatorsUseCase
        self.searchCreatorsByTagsUseCase = searchCreatorsByTagsUseCase
        self.getNewestCreatorsUseCase = getNewestCreatorsUseCase
    }
    
    // MARK: - Public Methods
    func loadInitialData() async {
        await withErrorHandling {
            await _ = (loadPopularCreators(), loadPopularTags(), loadNewArrivalCreators())
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
            createTag(id: "tag_007", display: "FPS", name: "fps", count: 500),
            createTag(id: "tag_009", display: "VTuber", name: "vtuber", count: 1100),
            createTag(id: "tag_013", display: "マインクラフト", name: "minecraft", count: 750),
            createTag(id: "tag_001", display: "ゲーム", name: "gaming", count: 1200),
            createTag(id: "tag_008", display: "RPG", name: "rpg", count: 400),
            createTag(id: "tag_011", display: "実況", name: "gameplay", count: 850),
            createTag(id: "tag_010", display: "配信", name: "streaming", count: 950),
            createTag(id: "tag_014", display: "プロゲーマー", name: "professional", count: 300),
            createTag(id: "tag_005", display: "技術", name: "tech", count: 700)
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
        let request = GetNewestCreatorsUseCaseRequest(limit: 20)
        let response = try? await getNewestCreatorsUseCase.execute(request: request)
        newArrivalCreators = response?.creators ?? []
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
