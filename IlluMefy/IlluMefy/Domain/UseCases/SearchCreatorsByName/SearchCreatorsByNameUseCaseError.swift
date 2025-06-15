//
//  SearchCreatorsByNameUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でクリエイターを検索するUseCaseのエラー
enum SearchCreatorsByNameUseCaseError: Error, UseCaseErrorProtocol {
    case emptyQuery
    case invalidQuery
    case repositoryError(CreatorRepositoryError)
    case unknownError
    
    var code: Int {
        switch self {
        case .emptyQuery: return 1001
        case .invalidQuery: return 1002
        case .repositoryError: return 1003
        case .unknownError: return 1999
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .repositoryError(let error): return error
        default: return nil
        }
    }
    
    var title: String {
        switch self {
        case .emptyQuery:
            return "検索エラー"
        case .invalidQuery:
            return "検索エラー"
        case .repositoryError:
            return "データ取得エラー"
        case .unknownError:
            return "予期しないエラー"
        }
    }
    
    var message: String {
        switch self {
        case .emptyQuery:
            return "検索キーワードを入力してください"
        case .invalidQuery:
            return "検索キーワードが無効です"
        case .repositoryError(let error):
            return error.message
        case .unknownError:
            return "予期しないエラーが発生しました"
        }
    }
}