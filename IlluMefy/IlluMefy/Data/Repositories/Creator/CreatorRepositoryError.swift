//
//  CreatorRepositoryError.swift
//  IlluMefy
//
//  Created by Haruto K. on 2025/06/08.
//

import Foundation

enum CreatorRepositoryError: Error, LocalizedError {
    case notFound
    case creatorNotFound
    case networkError
    case decodingError
    case unauthorized
    case serverError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .notFound:
            return "クリエイターが見つかりませんでした"
        case .creatorNotFound:
            return "指定されたクリエイターが見つかりませんでした"
        case .networkError:
            return "ネットワークエラーが発生しました"
        case .decodingError:
            return "データの読み込みに失敗しました"
        case .unauthorized:
            return "認証が必要です"
        case .serverError:
            return "サーバーエラーが発生しました"
        case .unknown(let error):
            return "エラーが発生しました: \(error.localizedDescription)"
        }
    }
}

extension CreatorRepositoryError: RepositoryErrorProtocol {
    var code: Int {
        switch self {
        case .notFound:
            return 404
        case .creatorNotFound:
            return 404
        case .networkError:
            return -1009
        case .decodingError:
            return -1000
        case .unauthorized:
            return 401
        case .serverError:
            return 500
        case .unknown:
            return -1
        }
    }
    
    var message: String {
        return self.errorDescription ?? "Unknown error"
    }
    
    var underlyingError: Error? {
        switch self {
        case .unknown(let error):
            return error
        default:
            return nil
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .networkError, .serverError:
            return true
        case .notFound, .creatorNotFound, .decodingError, .unauthorized, .unknown:
            return false
        }
    }
}
