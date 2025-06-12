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
    
    // MARK: - Initialization
    init(
        getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol,
        searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol
    ) {
        self.getPopularCreatorsUseCase = getPopularCreatorsUseCase
        self.searchCreatorsByTagsUseCase = searchCreatorsByTagsUseCase
    }
    
    // MARK: - Public Methods
    func onAppear() {
        Task {
            await loadInitialData()
        }
    }
    
    func loadInitialData() async {
        await withErrorHandling {
            await _ = (loadPopularCreators(), loadPopularTags(), loadRecommendedCreators(), loadNewArrivalCreators())
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
        // TODO: Implement when tag use case is available
        // For now, using mock data
        popularTags = [
            Tag(
                id: "1",
                displayName: "FPS",
                tagName: "fps",
                clickedCount: 1250,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "2",
                displayName: "VTuber",
                tagName: "vtuber",
                clickedCount: 890,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "3",
                displayName: "Minecraft",
                tagName: "minecraft",
                clickedCount: 720,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "4",
                displayName: "APEX",
                tagName: "apex-legends",
                clickedCount: 650,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "5",
                displayName: "Valorant",
                tagName: "valorant",
                clickedCount: 580,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "6",
                displayName: "歌ってみた",
                tagName: "singing",
                clickedCount: 420,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "7",
                displayName: "踊ってみた",
                tagName: "dance",
                clickedCount: 380,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "8",
                displayName: "プロゲーマー",
                tagName: "professional",
                clickedCount: 320,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
            Tag(
                id: "9",
                displayName: "レトロゲーム",
                tagName: "retro",
                clickedCount: 280,
                createdAt: Date(),
                updatedAt: Date(),
                parentTagId: nil,
                childTagIds: []
            ),
        ]
    }
    
    private func loadRecommendedCreators() async {
        // TODO: Implement recommendation logic
        // For now, reusing popular creators logic
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        let response = try? await getPopularCreatorsUseCase.execute(request: request)
        recommendedCreators = response?.creators ?? []
    }
    
    private func loadNewArrivalCreators() async {
        // TODO: Implement new arrivals logic
        // For now, reusing popular creators logic
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        let response = try? await getPopularCreatorsUseCase.execute(request: request)
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
