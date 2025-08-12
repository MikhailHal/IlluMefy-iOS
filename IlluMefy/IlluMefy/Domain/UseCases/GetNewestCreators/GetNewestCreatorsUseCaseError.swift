//
//  GetNewestCreatorsUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/08/12.
//

import Foundation

enum GetNewestCreatorsUseCaseError: Error, LocalizedError {
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

extension GetNewestCreatorsUseCaseError: UseCaseErrorProtocol {
    var code: Int {
        switch self {
        case .invalidLimit:
            return 4101
        case .repositoryError:
            return 4102
        case .unknown:
            return 4199
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