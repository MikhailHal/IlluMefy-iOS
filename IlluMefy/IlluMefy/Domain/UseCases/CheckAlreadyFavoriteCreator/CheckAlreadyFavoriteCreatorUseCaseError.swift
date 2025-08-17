//
//  CheckAlreadyFavoriteCreatorUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/17.
//

import Foundation

enum CheckAlreadyFavoriteCreatorUseCaseError: Error, UseCaseErrorProtocol {
    case invalidCreatorId
    case repositoryError(Error)
    case unexpectedError(Error)
    
    var code: Int {
        switch self {
        case .invalidCreatorId: return 4001
        case .repositoryError: return 4002
        case .unexpectedError: return 4999
        }
    }
    
    var message: String {
        switch self {
        case .invalidCreatorId:
            return "無効なクリエイターIDです"
        case .repositoryError(let error):
            return "データアクセスエラー: \(error.localizedDescription)"
        case .unexpectedError(let error):
            return "予期しないエラー: \(error.localizedDescription)"
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .repositoryError(let error), .unexpectedError(let error):
            return error
        case .invalidCreatorId:
            return nil
        }
    }
    
    var localizedDescription: String {
        return message
    }
}