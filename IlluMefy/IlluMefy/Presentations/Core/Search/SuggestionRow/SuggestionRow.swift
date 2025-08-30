//
//  SuggestionRow.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import SwiftUI

public struct SuggestionRow: View {
  public let suggestion: TagSuggestion
  public var onSelection: ((Tag) -> Void)

  public init(suggestion: TagSuggestion,
              onSelection: @escaping ((Tag) -> Void) = {_ in}
  ) {
    self.suggestion = suggestion
    self.onSelection = onSelection
  }

  public var body: some View {
    let stack =
      HStack {
          Image(systemName: "magnifyingglass")
          Text(suggestion.name).padding(.vertical, 3)
          Spacer()
      }
      .contentShape(Rectangle())
      return stack
          .onTapGesture {
              onSelection(suggestion.tag)
          }
  }
}

#Preview {
    let mockTags = [
        Tag(id: "1", displayName: "イラスト", tagName: "illustration", clickedCount: 100, createdAt: Date(), updatedAt: Date()),
        Tag(id: "2", displayName: "アニメーション", tagName: "animation", clickedCount: 80, createdAt: Date(), updatedAt: Date()),
        Tag(id: "3", displayName: "ゲーム実況", tagName: "game", clickedCount: 150, createdAt: Date(), updatedAt: Date()),
        Tag(id: "4", displayName: "音楽制作", tagName: "music", clickedCount: 60, createdAt: Date(), updatedAt: Date()),
        Tag(id: "5", displayName: "3DCG", tagName: "3dcg", clickedCount: 40, createdAt: Date(), updatedAt: Date())
    ]
    
    let suggestions = mockTags.map { TagSuggestion(tag: $0) }
    
    List(suggestions) { suggestion in
        SuggestionRow(
            suggestion: suggestion,
            onSelection: { _ in }
        )
    }
}
