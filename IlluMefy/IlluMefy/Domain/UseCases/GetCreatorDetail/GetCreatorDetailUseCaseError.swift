//
//  GetCreatorDetailUseCaseError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/14.
//

import Foundation

enum GetCreatorDetailUseCaseError: Error, LocalizedError, Equatable {
    case creatorNotFound
    case repositoryError(Error)
    case invalidRequest
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .creatorNotFound:
            return "指定されたクリエイターが見つかりませんでした"
        case .repositoryError(let error):
            return "データ取得エラー: \(error.localizedDescription)"
        case .invalidRequest:
            return "不正なリクエストです"
        case .unknown(let error):
            return "予期しないエラーが発生しました: \(error.localizedDescription)"
        }
    }
}

extension GetCreatorDetailUseCaseError: UseCaseErrorProtocol {
    var code: Int {
        switch self {
        case .creatorNotFound:
            return 404
        case .repositoryError:
            return 500
        case .invalidRequest:
            return 400
        case .unknown:
            return -1
        }
    }
    
    var message: String {
        return self.errorDescription ?? "Unknown error"
    }
    
    var underlyingError: Error? {
        switch self {
        case .repositoryError(let error), .unknown(let error):
            return error
        default:
            return nil
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .repositoryError:
            return true
        case .creatorNotFound, .invalidRequest, .unknown:
            return false
        }
    }
    
    // MARK: - Equatable
    static func == (lhs: GetCreatorDetailUseCaseError, rhs: GetCreatorDetailUseCaseError) -> Bool {
        switch (lhs, rhs) {
        case (.creatorNotFound, .creatorNotFound):
            return true
        case (.invalidRequest, .invalidRequest):
            return true
        case (.repositoryError(let lhsError), .repositoryError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
