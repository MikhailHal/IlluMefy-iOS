//
//  GetPopularTagsUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

enum GetPopularTagsUseCaseError: Error, LocalizedError {
    case invalidLimit
    case repositoryError(TagRepositoryError)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidLimit:
            return "取得件数が不正です"
        case .repositoryError(let error):
            return error.localizedDescription
        case .unknown(let error):
            return "エラーが発生しました: \(error.localizedDescription)"
        }
    }
}

extension GetPopularTagsUseCaseError: UseCaseErrorProtocol {
    var code: Int {
        switch self {
        case .invalidLimit:
            return 5001
        case .repositoryError:
            return 5002
        case .unknown:
            return 5999
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
        case .invalidLimit:
            return nil
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .repositoryError:
            return true
        case .invalidLimit, .unknown:
            return false
        }
    }
}