//
//  SearchViewModelProtocol.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/16.
//

import Foundation

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