//
//  SearchTagsByNameUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/15.
//

import Foundation

/// 名前でタグを検索するUseCaseのエラー
enum SearchTagsByNameUseCaseError: Error, UseCaseErrorProtocol {
    case emptyQuery
    case invalidQuery
    case repositoryError(TagRepositoryError)
    case unknownError
    
    var code: Int {
        switch self {
        case .emptyQuery: return 2001
        case .invalidQuery: return 2002
        case .repositoryError: return 2003
        case .unknownError: return 2999
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

/// タグリポジトリエラー（仮定義）
enum TagRepositoryError: Error {
    case notFound
    case networkError
    case serverError
    
    var message: String {
        switch self {
        case .notFound: return "タグが見つかりません"
        case .networkError: return "ネットワークエラー"
        case .serverError: return "サーバーエラー"
        }
    }
}