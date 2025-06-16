//
//  SearchState.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/16.
//

import Foundation

/// 検索画面の状態
enum SearchState {
    case initial
    case searching
    case loadedCreators([Creator])
    case empty
    case error(String, String) // title, message
}