//
//  SearchCreatorsByTagsUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

enum SearchCreatorsByTagsUseCaseError: Error, LocalizedError {
    case emptyTags
    case tooManyTags
    case repositoryError(CreatorRepositoryError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .emptyTags:
            return "検索するタグを選択してください"
        case .tooManyTags:
            return "タグは10個まで選択可能です"
        case .repositoryError(let error):
            return error.localizedDescription
        case .unknown(let error):
            return "エラーが発生しました: \(error.localizedDescription)"
        }
    }
}

extension SearchCreatorsByTagsUseCaseError: UseCaseErrorProtocol {
    var code: Int {
        switch self {
        case .emptyTags:
            return 3001
        case .tooManyTags:
            return 3002
        case .repositoryError:
            return 3003
        case .unknown:
            return 3999
        }
    }
    
    var message: String {
        return self.errorDescription ?? "Unknown error"
    }
    
    var underlyingError: Error? {
        switch self {
        case .repositoryError(let error):
            return error
        case .unknown(let error):
            return error
        case .emptyTags, .tooManyTags:
            return nil
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .repositoryError(let error):
            return error.isRetryable
        case .emptyTags, .tooManyTags, .unknown:
            return false
        }
    }
}
