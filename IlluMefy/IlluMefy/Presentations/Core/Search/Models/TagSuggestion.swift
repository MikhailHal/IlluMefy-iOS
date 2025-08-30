//
//  TagSuggestion.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import Foundation

/// タグ検索候補表示用Viewモデル
public struct TagSuggestion: Identifiable, Equatable {
    public let id: String
    let name: String
    let tag: Tag
    
    init(tag: Tag) {
        self.id = tag.id
        self.name = tag.displayName
        self.tag = tag
    }
}
