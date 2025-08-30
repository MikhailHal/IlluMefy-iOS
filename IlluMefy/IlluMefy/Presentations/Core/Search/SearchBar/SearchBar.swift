//
//  SearchBar.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/30.
//

import SwiftUI

public struct SearchBar: View {
  /// Search query text
  @Binding public var text: String

  /// Whether the search bar is in the editing state
  @Binding public var isEditing: Bool
  
  /// Focus state for the text field
  @FocusState private var isFocused: Bool

  private let placeholder: String
  private let searchBarStyle: SearchBarStyle
  private var onSubmit: () -> Void
  private var onChange: ((String) -> Void)

  public init(text: Binding<String>,
              isEditing: Binding<Bool>,
              searchBarStyle: SearchBarStyle,
              placeholder: String = "Search ...",
              onSubmit: @escaping () -> Void = {},
              onChange: @escaping (String) -> Void = {_ in },
  ) {
    _text = text
    _isEditing = isEditing
    self.placeholder = placeholder
    self.searchBarStyle = searchBarStyle
    self.onSubmit = onSubmit
    self.onChange = onChange
  }

  public var body: some View {
    HStack(spacing: Spacing.componentGrouping) {
      Image(systemName: "magnifyingglass")
        .font(.system(size: Typography.bodyRegular))
        .foregroundColor(Asset.Color.SearchBar.searchBarIcon.swiftUIColor)
      
      TextField(placeholder, text: $text, onCommit: {
        onSubmit()
      })
      .font(.system(size: Typography.bodyRegular))
      .foregroundColor(searchBarStyle.textColor)
      .tint(Asset.Color.Application.accent.swiftUIColor)
      .focused($isFocused)
      .onChange(of: isFocused) { _, newValue in
        isEditing = newValue
      }
      .onChange(of: text) { _, newValue in
        onChange(newValue)
      }
      if isEditing {
        Button(action: {
          isFocused = false
          text = ""
          let impactFeedback = UIImpactFeedbackGenerator(style: .light)
          impactFeedback.impactOccurred()
        }, label: {
          Image(systemName: "xmark.circle")
            .font(.system(size: Typography.bodyRegular))
            .foregroundColor(Asset.Color.SearchBar.searchBarIcon.swiftUIColor.opacity(0.6))
        })
        .buttonStyle(PlainButtonStyle())
      }
    }
    .padding(.horizontal, Spacing.medium)
    .padding(.vertical, Spacing.componentGrouping)
    .background(searchBarStyle.backgroundColor)
    .overlay(
      RoundedRectangle(cornerRadius: CornerRadius.button)
        .stroke(
          isEditing || !text.isEmpty ?
          searchBarStyle.focusedBorderColor :
          searchBarStyle.unfocusedBorderColor,
          lineWidth: 1
        )
    )
  }
}

#Preview {
    @Previewable @State var text = ""
    @Previewable @State var isEditing = true
    @Previewable @State var placeholder = "検索したいタグを入力してください"
    @Previewable var onSubmit: () -> Void = { }
  SearchBar(
        text: $text,
        isEditing: $isEditing,
        searchBarStyle: SearchBarStyle(),
        placeholder: placeholder,
        onSubmit: onSubmit,
    )
}
