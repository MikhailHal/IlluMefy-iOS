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
    var hitList = [] as [Creator]
    var state: SearchState = .initial
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
    private let getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol
    private let searchTagsWithAlgoliaUseCase: SearchTagsWithAlgoliaUseCaseProtocol
    
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
        getPopularCreatorsUseCase: GetPopularCreatorsUseCaseProtocol,
        searchTagsWithAlgoliaUseCase: SearchTagsWithAlgoliaUseCaseProtocol
    ) {
        self.searchTagsByNameUseCase = searchTagsByNameUseCase
        self.searchCreatorsByTagsUseCase = searchCreatorsByTagsUseCase
        self.saveSearchHistoryUseCase = saveSearchHistoryUseCase
        self.getSearchHistoryUseCase = getSearchHistoryUseCase
        self.clearSearchHistoryUseCase = clearSearchHistoryUseCase
        self.getPopularCreatorsUseCase = getPopularCreatorsUseCase
        self.searchTagsWithAlgoliaUseCase = searchTagsWithAlgoliaUseCase
    }
    
    // MARK: - Public Methods
    func search() async {
        isLoading = true
        state = .searching
        currentOffset = 0
        currentCreators = []
        
        guard !selectedTags.isEmpty else {
            // タグが選択されていない場合は人気クリエイターを表示
            let popularCreators = await getPopularCreatorList()
            state = .showingResults(creators: popularCreators)
            isLoading = false
            return
        }
        
        do {
            let request = SearchCreatorsByTagsUseCaseRequest(
                tagIds: selectedTags.map { $0.id },
                searchMode: .any,
                sortOrder: .popularity,
                offset: 0,
                limit: pageSize
            )
            
            let response = try await searchCreatorsByTagsUseCase.execute(request: request)
            currentCreators = response.creators
            totalCount = response.totalCount
            hasMore = response.hasMore
            currentOffset = response.creators.count
            
            state = response.creators.isEmpty ? .empty : .showingResults(creators: response.creators)
        } catch {
            print("Search error: \(error)")
            state = .error(L10n.Common.error, error.localizedDescription)
        }
        
        isLoading = false
    }
    
    func clearHistory() async {
        return
    }
    
    func addSearchHistory(tag: Tag) async {
        return
    }
    
    func loadMore() async -> [Creator] {
        guard hasMore && !isLoading else { return [] }
        
        isLoading = true
        
        do {
            let request = SearchCreatorsByTagsUseCaseRequest(
                tagIds: selectedTags.map { $0.id },
                searchMode: .all,
                sortOrder: .popularity,
                offset: currentOffset,
                limit: pageSize
            )
            
            let response = try await searchCreatorsByTagsUseCase.execute(request: request)
            let newCreators = response.creators
            
            currentCreators.append(contentsOf: newCreators)
            currentOffset += newCreators.count
            hasMore = response.hasMore
            
            state = .showingResults(creators: currentCreators)
            
            isLoading = false
            return newCreators
        } catch {
            print("Load more error: \(error)")
            isLoading = false
            return []
        }
    }
    
    func getSuggestions(query: String) async {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            // クエリが空の場合は何もしない
            return
        }
        
        do {
            let request = SearchTagsWithAlgoliaUseCaseRequest(
                query: query,
                limit: 20
            )
            let tags = try await searchTagsWithAlgoliaUseCase.execute(request: request)
            
            let suggestions = tags.map { tag in
                TagSuggestion(tag: tag)
            }
            state = .editing(suggestions: suggestions)
        } catch {
            print("Error fetching suggestions: \(error)")
            state = .editing(suggestions: [])
        }
    }
    
    func addSearchHistory() async {
        return
    }
    
    func onTappedSuggestion(tag: Tag) {
        searchText = ""
        selectedTags.append(tag)
        Task {
            await search()
        }
    }
    
    func getPopularCreatorList() async -> [Creator] {
        let request = GetPopularCreatorsUseCaseRequest(limit: 20)
        var response: [Creator] = []
        do {
            response = try await getPopularCreatorsUseCase.execute(request: request).creators
            hitList = response // hitListを更新
            if selectedTags.isEmpty && searchText.isEmpty {
                state = .showingResults(creators: response)
            }
        } catch {
            print(error)
        }
        return response
    }
    
    func onTappedTagForDeletion(tag: Tag) {
        selectedTags.remove(at: selectedTags.firstIndex(of: tag)!)
        
        // タグが全て削除された場合は人気クリエイターを表示
        if selectedTags.isEmpty {
            Task {
                let popularCreators = await getPopularCreatorList()
                state = .showingResults(creators: popularCreators)
            }
        }
    }
}
