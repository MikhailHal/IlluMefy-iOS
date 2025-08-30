//
//  SearchTagsResponse.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation
import AlgoliaSearchClient

/// Algolia検索タグレスポンス
struct SearchTagsResponse {
    let tags: [SearchTagItem]
    let totalCount: Int
}

/// Algoliaタグアイテム
struct SearchTagItem: Codable {
    let objectID: ObjectID
    let name: String
    let id: String
    let viewCount: Int?
}