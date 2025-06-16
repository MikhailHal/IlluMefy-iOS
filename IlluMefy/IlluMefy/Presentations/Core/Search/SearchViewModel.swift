//
//  SearchViewModel.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation
import Combine

/// 検索画面の状態
enum SearchState {
    case initial
    case searching
    case loadedCreators([Creator])
    case empty
    case error(String, String) // title, message
}

/// 検索ViewModelプロトコル
@MainActor
protocol SearchViewModelProtocol: ObservableObject {
    var searchText: String { get set }
    var suggestions: [Tag] { get }
    var selectedTags: [Tag] { get }
    var state: SearchState { get }
    var searchHistory: [String] { get }
    var isLoading: Bool { get }
    var hasMore: Bool { get }
    
    func search() async
    func loadMore() async
    func clearSearch()
    func selectFromHistory(_ query: String)
    func addTagsFromHistory(_ query: String)
    func deleteFromHistory(_ query: String) async
    func clearHistory() async
    func selectTag(_ tag: Tag)
    func removeTag(_ tag: Tag)
    func addSelectedTag()
    func addSelectedTagFromSuggestion(_ tag: Tag)
}

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
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedQuery.isEmpty {
            suggestions = []
            return
        }
        
        // ひらがな・カタカナ正規化した検索文字列
        let normalizedQuery = normalizeJapaneseText(trimmedQuery)
        
        // 完全一致するタグを確認
        let exactMatchTag = allTags.first { tag in
            let normalizedDisplayName = normalizeJapaneseText(tag.displayName)
            return normalizedDisplayName.lowercased() == normalizedQuery.lowercased()
        }
        
        // 完全一致するタグが既に選択済みの場合は候補を表示しない
        if let exactTag = exactMatchTag, selectedTags.contains(where: { $0.id == exactTag.id }) {
            suggestions = []
            return
        }
        
        // 入力文字の言語を判定（より寛容に）
        let containsJapanese = trimmedQuery.contains { char in
            let scalar = char.unicodeScalars.first!
            return CharacterSet.init(charactersIn: "\u{3040}"..."\u{309F}")
                .union(CharacterSet.init(charactersIn: "\u{30A0}"..."\u{30FF}"))
                .union(CharacterSet.init(charactersIn: "\u{4E00}"..."\u{9FAF}"))
                .contains(scalar)
        }
        
        // 完全一致するタグが存在し、まだ選択されていない場合は、それを最優先で表示
        var filteredTags: [Tag] = []
        
        if let exactTag = exactMatchTag {
            filteredTags.append(exactTag)
        }
        
        // その他のマッチするタグを追加
        let otherMatchingTags = allTags.filter { tag in
            guard !selectedTags.contains(where: { $0.id == tag.id }) else { return false }
            
            // 完全一致タグは既に追加済みなのでスキップ
            if let exactTag = exactMatchTag, tag.id == exactTag.id {
                return false
            }
            
            if containsJapanese {
                // 日本語を含む入力の場合：正規化した文字列で部分一致検索
                let normalizedDisplayName = normalizeJapaneseText(tag.displayName)
                return normalizedDisplayName.localizedCaseInsensitiveContains(normalizedQuery)
            } else {
                // 英語のみの入力の場合：英語tagNameを対象に前方一致 + 正規化した日本語displayNameも部分一致で検索
                let englishMatch = tag.tagName.lowercased().hasPrefix(trimmedQuery.lowercased())
                let normalizedDisplayName = normalizeJapaneseText(tag.displayName)
                let japaneseMatch = normalizedDisplayName.localizedCaseInsensitiveContains(normalizedQuery)
                return englishMatch || japaneseMatch
            }
        }
        
        filteredTags.append(contentsOf: otherMatchingTags)
        
        // 完全一致タグが最初にある場合はソートしない（完全一致を最優先で保持）
        let sortedTags: [Tag]
        if let exactTag = exactMatchTag, !filteredTags.isEmpty && filteredTags[0].id == exactTag.id {
            // 完全一致タグ以外をソート
            let otherTags = Array(filteredTags.dropFirst())
            let sortedOtherTags = otherTags.sorted { tag1, tag2 in
                let tag1StartsWithQuery: Bool
                let tag2StartsWithQuery: Bool
                
                if containsJapanese {
                    // 日本語入力時は正規化したdisplayNameで前方一致を判定
                    let normalizedTag1 = normalizeJapaneseText(tag1.displayName)
                    let normalizedTag2 = normalizeJapaneseText(tag2.displayName)
                    tag1StartsWithQuery = normalizedTag1.lowercased().hasPrefix(normalizedQuery.lowercased())
                    tag2StartsWithQuery = normalizedTag2.lowercased().hasPrefix(normalizedQuery.lowercased())
                } else {
                    // 英語入力時はtagNameまたは正規化したdisplayNameのいずれかで前方一致を判定
                    let tag1EnglishPrefix = tag1.tagName.lowercased().hasPrefix(trimmedQuery.lowercased())
                    let normalizedTag1 = normalizeJapaneseText(tag1.displayName)
                    let tag1JapanesePrefix = normalizedTag1.lowercased().hasPrefix(normalizedQuery.lowercased())
                    tag1StartsWithQuery = tag1EnglishPrefix || tag1JapanesePrefix
                    
                    let tag2EnglishPrefix = tag2.tagName.lowercased().hasPrefix(trimmedQuery.lowercased())
                    let normalizedTag2 = normalizeJapaneseText(tag2.displayName)
                    let tag2JapanesePrefix = normalizedTag2.lowercased().hasPrefix(normalizedQuery.lowercased())
                    tag2StartsWithQuery = tag2EnglishPrefix || tag2JapanesePrefix
                }
                
                if tag1StartsWithQuery && !tag2StartsWithQuery {
                    return true
                } else if !tag1StartsWithQuery && tag2StartsWithQuery {
                    return false
                } else {
                    return tag1.clickedCount > tag2.clickedCount
                }
            }
            sortedTags = [exactTag] + sortedOtherTags
        } else {
            // 完全一致タグがない場合は通常のソート
            sortedTags = filteredTags.sorted { tag1, tag2 in
                return tag1.clickedCount > tag2.clickedCount
            }
        }
        
        // 上位5件
        suggestions = Array(sortedTags.prefix(5))
    }
    
    /// ひらがな・カタカナを正規化する（すべてひらがなに統一）
    private func normalizeJapaneseText(_ text: String) -> String {
        return text.applyingTransform(.hiraganaToKatakana, reverse: true) ?? text
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
        
        for tagName in tagNames {
            // タグ名に一致するタグを検索
            if let matchingTag = allTags.first(where: { tag in
                tag.displayName == tagName
            }) {
                // 重複チェック
                if !selectedTags.contains(where: { $0.id == matchingTag.id }) {
                    selectedTags.append(matchingTag)
                }
            }
        }
        
        // テキストをクリア
        searchText = ""
        suggestions = []
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
    }
    
    func addSelectedTag() {
        // 現在のテキストに一致するタグを探す
        guard let matchingTag = allTags.first(where: { 
            $0.displayName.lowercased() == searchText.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
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
