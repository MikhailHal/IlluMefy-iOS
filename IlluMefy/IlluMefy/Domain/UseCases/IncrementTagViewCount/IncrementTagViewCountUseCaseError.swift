//
//  IncrementTagViewCountUseCaseError.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ閲覧数増加 UseCase エラー
enum IncrementTagViewCountUseCaseError: LocalizedError {
    case invalidTagId
    case repositoryError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidTagId:
            return "タグIDが無効です"
        case .repositoryError(let error):
            return "閲覧数更新エラー: \(error.localizedDescription)"
        case .unknownError:
            return "予期しないエラーが発生しました"
        }
    }
}