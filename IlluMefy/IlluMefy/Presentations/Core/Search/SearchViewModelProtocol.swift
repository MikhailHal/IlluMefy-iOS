//
//  SearchViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/16.
//

import Foundation

/// 検索ViewModelプロトコル
@MainActor
protocol SearchViewModelProtocol {
    var searchText: String { get set }
    var suggestions: [TagSuggestion] { get }
    var selectedTags: [Tag] { get }
    var state: SearchState { get }
    var searchHistory: [String] { get }
    var isLoading: Bool { get }
    var hasMore: Bool { get }
    
    func search() async
    func getSuggestions() async
    func clearHistory() async
    func addSearchHistory () async
    func loadMore() async -> [Creator]
    func onTappedSuggestion (tag: Tag)
}
