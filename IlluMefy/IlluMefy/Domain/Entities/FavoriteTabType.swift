//
//  FavoriteTabType.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/28.
//

import Foundation

// MARK: - FavoriteTabType
enum FavoriteTabType: CaseIterable {
    case favorites
    case history
    
    var displayName: String {
        switch self {
        case .favorites:
            return L10n.Favorite.favorites
        case .history:
            return L10n.Favorite.history
        }
    }
    
    var icon: String {
        switch self {
        case .favorites:
            return "heart.fill"
        case .history:
            return "clock.fill"
        }
    }
}