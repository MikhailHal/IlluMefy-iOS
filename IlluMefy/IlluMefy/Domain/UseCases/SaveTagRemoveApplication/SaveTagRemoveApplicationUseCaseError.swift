//
//  SaveTagRemoveApplicationUseCaseError.swift
//  IlluMefy
//
//  Created by Claude on 2025/08/31.
//

import Foundation

/// タグ削除申請保存 UseCase エラー
enum SaveTagRemoveApplicationUseCaseError: LocalizedError {
    case invalidTagName
    case invalidUserUid
    case invalidCreatorId
    case repositoryError(Error)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidTagName:
            return "タグ名が無効です"
        case .invalidUserUid:
            return "ユーザー情報が無効です"
        case .invalidCreatorId:
            return "クリエイター情報が無効です"
        case .repositoryError(let error):
            return "保存エラー: \(error.localizedDescription)"
        case .unknownError:
            return "予期しないエラーが発生しました"
        }
    }
}