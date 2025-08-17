//
//  ToggleFavoriteCreatorUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/17.
//

import Foundation

enum ToggleFavoriteCreatorUseCaseError: Error, UseCaseErrorProtocol {
    case invalidCreatorId
    case networkError(Error)
    case repositoryError(Error)
    case unexpectedError(Error)
    
    var code: Int {
        switch self {
        case .invalidCreatorId: return 3001
        case .networkError: return 3002
        case .repositoryError: return 3003
        case .unexpectedError: return 3999
        }
    }
    
    var message: String {
        switch self {
        case .invalidCreatorId:
            return "無効なクリエイターIDです"
        case .networkError(let error):
            return "ネットワークエラー: \(error.localizedDescription)"
        case .repositoryError(let error):
            return "データアクセスエラー: \(error.localizedDescription)"
        case .unexpectedError(let error):
            return "予期しないエラー: \(error.localizedDescription)"
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .networkError(let error), .repositoryError(let error), .unexpectedError(let error):
            return error
        case .invalidCreatorId:
            return nil
        }
    }
    
    var localizedDescription: String {
        return message
    }
}