//
//  SearchViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
import Observation

/// 検索ViewModel
@MainActor
@Observable
final class SearchViewModel: SearchViewModelProtocol {
    
    // MARK: - Observable Properties
    var searchText: String = ""
    var selectedTags: [Tag] = []
    var isEditing: Bool = false
    var suggestions: [TagSuggestion] = []
    var popularCreatorList = [] as [Creator]
    private(set) var state: SearchState = .initial
    private(set) var searchHistory: [String] = []
    private(set) var isLoading = false
    private(set) var hasMore = false
    private(set) var totalCount = 0
    
    // MARK: - Private Properties
    private let searchTagsByNameUseCase: SearchTagsByNameUseCaseProtocol
    private let searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol
    private let saveSearchHistoryUseCase: SaveSearchHistoryUseCase
    private let getSearchHistoryUseCase: GetSearchHistoryUseCase
    private let clearSearchHistoryUseCase: ClearSearchHistoryUseCase
    private let tagSuggestionService = TagSuggestionService()
    private let getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol
    
    private var currentCreators: [Creator] = []
    private var currentOffset = 0
    private let pageSize = 20
    private var allTags: [Tag] = []
    private var searchTextDebounceTask: Task<Void, Never>?
    private var selectedTagsDebounceTask: Task<Void, Never>?
    
    // MARK: - Initialization
    init(
        searchTagsByNameUseCase: SearchTagsByNameUseCaseProtocol,
        searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol,
        saveSearchHistoryUseCase: SaveSearchHistoryUseCase,
        getSearchHistoryUseCase: GetSearchHistoryUseCase,
        clearSearchHistoryUseCase: ClearSearchHistoryUseCase,
        getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol
    ) {
        self.searchTagsByNameUseCase = searchTagsByNameUseCase
        self.searchCreatorsByTagsUseCase = searchCreatorsByTagsUseCase
        self.saveSearchHistoryUseCase = saveSearchHistoryUseCase
        self.getSearchHistoryUseCase = getSearchHistoryUseCase
        self.clearSearchHistoryUseCase = clearSearchHistoryUseCase
        self.getPopularCreatorsUseCase = getPopularCreatorsUseCase
    }
    
    // MARK: - Public Methods
    func search() async {
        
        isLoading = true
        state = .searching
        currentOffset = 0
        currentCreators = []
        
        isLoading = false
    }
    
    func clearHistory() async {
        return
    }
    
    func addSearchHistory(tag: Tag) async {
        return
    }
    
    func loadMore() async -> [Creator] {
        return []
    }
    
    func getSuggestions() async {
        return
    }
    
    func addSearchHistory() async {
        return
    }
    
    func onTappedSuggestion(tag: Tag) {
        selectedTags.append(tag)
    }
    
    func getPopularCreatorList() async -> [Creator] {
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        var response: [Creator] = []
        do {
            response = try await getPopularCreatorsUseCase.execute(request: request).creators
            state = .loadedPopularCreators(response)
        } catch {
            print(error)
        }
        return response
    }
}
