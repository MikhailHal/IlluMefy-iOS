//
//  SearchBarStyle.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/30.
//

import SwiftUI

/// SearchBarのスタイル設定
public struct SearchBarStyle {
    // MARK: - Colors
    let backgroundColor: Color
    let textColor: Color
    let unfocusedBorderColor: Color
    let focusedBorderColor: Color
    
    init(
        backgroundColor: Color = Asset.Color.SearchBar.searchBarBackground.swiftUIColor,
        textColor: Color = Asset.Color.SearchBar.searchBarText.swiftUIColor,
        unfocusedBorderColor: Color = Asset.Color.SearchBar.searchBarBorder.swiftUIColor,
        focusedBorderColor: Color = Asset.Color.SearchBar.searchBarBorderFocused.swiftUIColor
    ) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.unfocusedBorderColor = unfocusedBorderColor
        self.focusedBorderColor = focusedBorderColor
    }
}
