//
//  GetTagListByTagIdListUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/08/14.
//

import Foundation

enum GetTagListByTagIdListUseCaseError: Error, UseCaseErrorProtocol {
    case invalidTagIdList(String)
    case repositoryError(Error)
    case networkError(Error)
    case unknown(Error?)
    
    var code: Int {
        switch self {
        case .invalidTagIdList: return 3001
        case .repositoryError: return 3002
        case .networkError: return 3003
        case .unknown: return 3999
        }
    }
    
    var message: String {
        switch self {
        case .invalidTagIdList(let message):
            return "タグIDリストが無効です: \(message)"
        case .repositoryError(let error):
            if let repoError = error as? RepositoryErrorProtocol {
                return "データ取得に失敗しました: \(repoError.message)"
            }
            return "データ取得に失敗しました: \(error.localizedDescription)"
        case .networkError(let error):
            return "ネットワークエラーが発生しました: \(error.localizedDescription)"
        case .unknown(let error):
            if let error = error {
                return "不明なエラーが発生しました: \(error.localizedDescription)"
            }
            return "不明なエラーが発生しました"
        }
    }
    
    var underlyingError: Error? {
        switch self {
        case .repositoryError(let error):
            return error
        case .networkError(let error):
            return error
        case .unknown(let error):
            return error
        case .invalidTagIdList:
            return nil
        }
    }
    
    var localizedDescription: String {
        return message
    }
}