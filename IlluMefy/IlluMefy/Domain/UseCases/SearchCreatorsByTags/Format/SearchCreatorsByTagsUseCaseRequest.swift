//
//  SearchCreatorsByTagsUseCaseRequest.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

/// タグ検索モード
public enum TagSearchMode {
    case all    // AND検索 - すべてのタグを含む
    case any    // OR検索 - いずれかのタグを含む
}

struct SearchCreatorsByTagsUseCaseRequest {
    let tagIds: [String]
    let searchMode: TagSearchMode
    let sortOrder: CreatorSortOrder
    let offset: Int
    let limit: Int
    
    init(
        tagIds: [String],
        searchMode: TagSearchMode = .any,
        sortOrder: CreatorSortOrder = .popularity,
        offset: Int = 0,
        limit: Int = 20
    ) {
        self.tagIds = tagIds
        self.searchMode = searchMode
        self.sortOrder = sortOrder
        self.offset = offset
        self.limit = limit
    }
}
