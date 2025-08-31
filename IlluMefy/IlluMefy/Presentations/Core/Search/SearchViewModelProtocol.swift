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
    var selectedTags: [Tag] { get }
    var state: SearchState { get set }
    var searchHistory: [String] { get }
    var isLoading: Bool { get }
    var hasMore: Bool { get }
    var hitList: [Creator] { get }
    
    func initialize(with initialTag: Tag?)
    func search() async
    func getSuggestions(query: String) async
    func clearHistory() async
    func addSearchHistory () async
    func loadMore() async -> [Creator]
    func getPopularCreatorList() async -> [Creator]
    func onTappedSuggestion (tag: Tag)
    func onTappedTagForDeletion (tag: Tag)
}
