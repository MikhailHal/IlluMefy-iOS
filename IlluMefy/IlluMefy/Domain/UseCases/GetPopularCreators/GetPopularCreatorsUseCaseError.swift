//
//  GetPopularCreatorsUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

enum GetPopularCreatorsUseCaseError: Error, LocalizedError {
    case invalidLimit
    case repositoryError(CreatorRepositoryError)
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

extension GetPopularCreatorsUseCaseError: UseCaseErrorProtocol {
    var code: Int {
        switch self {
        case .invalidLimit:
            return 4001
        case .repositoryError:
            return 4002
        case .unknown:
            return 4999
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
        case .repositoryError(let error):
            return error.isRetryable
        case .invalidLimit, .unknown:
            return false
        }
    }
}
