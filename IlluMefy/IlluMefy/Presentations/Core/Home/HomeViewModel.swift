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
    private let getPopularTagsUseCase: GetPopularTagsUseCaseProtocol
    
    // MARK: - Initialization
    init(
        getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol,
        searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol,
        getNewestCreatorsUseCase: GetNewestCreatorsUseCaseProtocol,
        getPopularTagsUseCase: GetPopularTagsUseCaseProtocol
    ) {
        self.getPopularCreatorsUseCase = getPopularCreatorsUseCase
        self.searchCreatorsByTagsUseCase = searchCreatorsByTagsUseCase
        self.getNewestCreatorsUseCase = getNewestCreatorsUseCase
        self.getPopularTagsUseCase = getPopularTagsUseCase
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
        let request = GetPopularTagsUseCaseRequest(limit: 10)
        let response = try? await getPopularTagsUseCase.execute(request: request)
        popularTags = response?.tags ?? []
    }
    
    private func loadRecommendedCreators() async {
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        let response = try? await getPopularCreatorsUseCase.execute(request: request)
        recommendedCreators = response?.creators ?? []
    }
    
    private func loadNewArrivalCreators() async {
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
