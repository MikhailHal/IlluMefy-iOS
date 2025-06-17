//
//  SearchViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
import Combine

/// 検索ViewModel
@MainActor
final class SearchViewModel: SearchViewModelProtocol {
    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published private(set) var suggestions: [Tag] = []
    @Published private(set) var selectedTags: [Tag] = []
    @Published private(set) var state: SearchState = .initial
    @Published private(set) var searchHistory: [String] = []
    @Published private(set) var isLoading = false
    @Published private(set) var hasMore = false
    
    // MARK: - Private Properties
    private let searchTagsByNameUseCase: SearchTagsByNameUseCaseProtocol
    private let searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol
    private let saveSearchHistoryUseCase: SaveSearchHistoryUseCase
    private let getSearchHistoryUseCase: GetSearchHistoryUseCase
    private let tagSuggestionService = TagSuggestionService()
    
    private var cancellables = Set<AnyCancellable>()
    private var currentCreators: [Creator] = []
    private var currentOffset = 0
    private let pageSize = 20
    private var allTags: [Tag] = []
    
    // MARK: - Initialization
    init(
        searchTagsByNameUseCase: SearchTagsByNameUseCaseProtocol,
        searchCreatorsByTagsUseCase: SearchCreatorsByTagsUseCaseProtocol,
        saveSearchHistoryUseCase: SaveSearchHistoryUseCase,
        getSearchHistoryUseCase: GetSearchHistoryUseCase
    ) {
        self.searchTagsByNameUseCase = searchTagsByNameUseCase
        self.searchCreatorsByTagsUseCase = searchCreatorsByTagsUseCase
        self.saveSearchHistoryUseCase = saveSearchHistoryUseCase
        self.getSearchHistoryUseCase = getSearchHistoryUseCase
        
        setupBindings()
        loadSearchHistory()
        loadAllTags()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // 検索テキストのオートコンプリート（リアルタイム検索のためdebounceを短縮）
        $searchText
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.updateSuggestions(query: query)
            }
            .store(in: &cancellables)
        
        // 選択されたタグの変更を監視して検索実行
        $selectedTags
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.performSearch()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadSearchHistory() {
        Task {
            do {
                let history = try await getSearchHistoryUseCase.execute()
                await MainActor.run {
                    self.searchHistory = history
                }
            } catch {
                // 履歴の読み込みエラーは無視（クリティカルではない）
                print("Failed to load search history: \(error)")
            }
        }
    }
    
    private func loadAllTags() {
        Task {
            do {
                // 全タグを取得してキャッシュ
                let result = try await searchTagsByNameUseCase.execute(
                    request: SearchTagsByNameUseCaseRequest(
                        andQuery: "",
                        orQuery: "",
                        offset: 0,
                        limit: 1000 // 大きな値で全タグを取得
                    )
                )
                await MainActor.run {
                    self.allTags = result.tags
                }
            } catch {
                print("Failed to load all tags: \(error)")
            }
        }
    }
    
    private func updateSuggestions(query: String) {
        suggestions = tagSuggestionService.generateSuggestions(
            query: query,
            allTags: allTags,
            selectedTags: selectedTags
        )
    }
    
    private func performSearch() async {
        // 選択されたタグがない場合は初期状態に戻す
        guard !selectedTags.isEmpty else {
            state = .initial
            currentCreators = []
            hasMore = false
            return
        }
        
        await search()
    }
    
    // MARK: - Public Methods
    func search() async {
        isLoading = true
        state = .searching
        currentOffset = 0
        currentCreators = []
        
        await searchCreatorsBySelectedTags()
        
        isLoading = false
    }
    
    private func searchCreatorsBySelectedTags() async {
        do {
            // 選択されたタグを全て含むクリエイターを検索（AND検索）
            let tagIds = selectedTags.map { $0.id }
            let request = SearchCreatorsByTagsUseCaseRequest(
                tagIds: tagIds,
                searchMode: .all,
                offset: currentOffset,
                limit: pageSize
            )
            let result = try await searchCreatorsByTagsUseCase.execute(request: request)
            
            // 検索履歴に保存
            let searchQuery = buildSearchQueryForHistory()
            if !searchQuery.isEmpty {
                try await saveSearchHistoryUseCase.execute(query: searchQuery)
                loadSearchHistory()
            }
            
            currentCreators = result.creators
            hasMore = result.hasMore
            
            if result.creators.isEmpty {
                state = .empty
            } else {
                state = .loadedCreators(result.creators)
            }
        } catch let error as SearchCreatorsByTagsUseCaseError {
            state = .error(error.title, error.message)
        } catch {
            state = .error("クリエイター検索エラー", "クリエイター検索中にエラーが発生しました")
        }
    }
    
    private func buildSearchQueryForHistory() -> String {
        return selectedTags.map { $0.displayName }.joined(separator: ",")
    }
    
    func loadMore() async {
        guard hasMore && !isLoading else { return }
        
        isLoading = true
        currentOffset += pageSize
        
        do {
            let tagIds = selectedTags.map { $0.id }
            let request = SearchCreatorsByTagsUseCaseRequest(
                tagIds: tagIds,
                searchMode: .all,
                offset: currentOffset,
                limit: pageSize
            )
            let result = try await searchCreatorsByTagsUseCase.execute(request: request)
            
            // 既存の結果に追加
            currentCreators.append(contentsOf: result.creators)
            hasMore = result.hasMore
            state = .loadedCreators(currentCreators)
            
        } catch {
            // エラーは無視してローディングだけ停止
        }
        
        isLoading = false
    }
    
    func clearSearch() {
        searchText = ""
        selectedTags = []
        suggestions = []
        state = .initial
        currentCreators = []
        hasMore = false
        currentOffset = 0
    }
    
    func selectFromHistory(_ query: String) {
        // 履歴からの復元は簡略化のため省略
        // 必要に応じて実装
    }
    
    func addTagsFromHistory(_ query: String) {
        // 履歴クエリはカンマ区切りのタグ名の形式
        let tagNames = query.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        var tagsAdded = false
        for tagName in tagNames {
            // タグ名に一致するタグを検索
            if let matchingTag = allTags.first(where: { tag in
                tag.displayName == tagName
            }) {
                // 重複チェック
                if !selectedTags.contains(where: { $0.id == matchingTag.id }) {
                    selectedTags.append(matchingTag)
                    tagsAdded = true
                }
            }
        }
        
        // テキストをクリア
        searchText = ""
        suggestions = []
        
        // タグが追加されたら自動的に検索
        if tagsAdded {
            Task {
                await search()
            }
        }
    }
    
    // MARK: - Tag Helper Methods
    
    /// タグIDから表示名を取得
    func getTagDisplayName(for tagId: String) -> String {
        allTags.first { $0.id == tagId }?.displayName ?? tagId
    }
    
    /// 複数のタグIDからTag配列を取得
    func getTagsForIds(_ tagIds: [String]) -> [Tag] {
        tagIds.compactMap { tagId in
            allTags.first { $0.id == tagId }
        }
    }
    
    // MARK: - Tag Selection Methods
    
    func selectTag(_ tag: Tag) {
        // オートコンプリート：選択されたタグ名をテキストフィールドに設定
        searchText = tag.displayName
        
        // 候補を非表示
        suggestions = []
    }
    
    func addSelectedTagFromSuggestion(_ tag: Tag) {
        // 重複チェック
        guard !selectedTags.contains(where: { $0.id == tag.id }) else { return }
        
        // タグを選択リストに直接追加
        selectedTags.append(tag)
        
        // テキストと候補をクリア
        searchText = ""
        suggestions = []
        
        // タグ選択後、自動的に検索を実行
        Task {
            await search()
        }
    }
    
    func addSelectedTag() {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 正規化して一致するタグを探す
        guard let matchingTag = allTags.first(where: { tag in
            let normalizedDisplayName = tagSuggestionService.normalizeJapaneseText(tag.displayName)
            let normalizedQuery = tagSuggestionService.normalizeJapaneseText(trimmedText)
            return normalizedDisplayName.lowercased() == normalizedQuery.lowercased()
        }) else { return }
        
        // 重複チェック
        guard !selectedTags.contains(where: { $0.id == matchingTag.id }) else { return }
        
        // タグを選択リストに追加
        selectedTags.append(matchingTag)
        
        // テキストをクリア
        searchText = ""
        suggestions = []
    }
    
    func removeTag(_ tag: Tag) {
        selectedTags.removeAll { $0.id == tag.id }
        
        // タグ削除後、残りのタグで再検索（タグが0個になったら初期状態に戻す）
        Task {
            if selectedTags.isEmpty {
                state = .initial
                currentCreators = []
                hasMore = false
                currentOffset = 0
            } else {
                await search()
            }
        }
    }
    
    func deleteFromHistory(_ query: String) async {
        do {
            try await saveSearchHistoryUseCase.execute(query: query)
            loadSearchHistory()
        } catch {
            print("Failed to delete from history: \(error)")
        }
    }
    
    func clearHistory() async {
        loadSearchHistory()
    }
}
