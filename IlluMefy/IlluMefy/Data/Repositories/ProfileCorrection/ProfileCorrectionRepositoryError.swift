//
//  ProfileCorrectionRepositoryError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼リポジトリエラー
enum ProfileCorrectionRepositoryError: Error, RepositoryErrorProtocol {
    
    // MARK: - Error Cases
    
    /// ネットワークエラー
    case networkError
    
    /// 無効なリクエスト
    case invalidRequest(String)
    
    /// 認証エラー
    case authenticationError
    
    /// 権限エラー
    case authorizationError
    
    /// 修正依頼が見つからない
    case requestNotFound
    
    /// 修正依頼の上限に達した
    case requestLimitExceeded
    
    /// 重複した修正依頼
    case duplicateRequest
    
    /// サーバーエラー
    case serverError(Int)
    
    /// 不明なエラー
    case unknown(Error)
    
    // MARK: - RepositoryErrorProtocol
    
    var code: Int {
        switch self {
        case .networkError:
            return 4001
        case .invalidRequest:
            return 4002
        case .authenticationError:
            return 4003
        case .authorizationError:
            return 4004
        case .requestNotFound:
            return 4005
        case .requestLimitExceeded:
            return 4006
        case .duplicateRequest:
            return 4007
        case .serverError(let statusCode):
            return 4000 + statusCode
        case .unknown:
            return 4999
        }
    }
    
    var message: String {
        return errorDescription ?? "不明なエラーが発生しました"
    }
    
    var underlyingError: Error? {
        switch self {
        case .unknown(let error):
            return error
        default:
            return nil
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "ネットワーク接続を確認してください"
        case .invalidRequest(let message):
            return "リクエストが無効です: \(message)"
        case .authenticationError:
            return "認証に失敗しました"
        case .authorizationError:
            return "権限がありません"
        case .requestNotFound:
            return "修正依頼が見つかりません"
        case .requestLimitExceeded:
            return "修正依頼の上限に達しました"
        case .duplicateRequest:
            return "同じ修正依頼が既に送信されています"
        case .serverError(let code):
            return "サーバーエラーが発生しました (Code: \(code))"
        case .unknown(let error):
            return "予期しないエラーが発生しました: \(error.localizedDescription)"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .networkError:
            return "ネットワーク接続に失敗しました"
        case .invalidRequest:
            return "リクエストが無効です"
        case .authenticationError:
            return "認証に失敗しました"
        case .authorizationError:
            return "権限が不足しています"
        case .requestNotFound:
            return "修正依頼が見つかりませんでした"
        case .requestLimitExceeded:
            return "修正依頼の制限に達しました"
        case .duplicateRequest:
            return "重複した修正依頼です"
        case .serverError:
            return "サーバーでエラーが発生しました"
        case .unknown:
            return "不明なエラーが発生しました"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .networkError:
            return "インターネット接続を確認して再度お試しください"
        case .invalidRequest:
            return "入力内容を確認して再度お試しください"
        case .authenticationError:
            return "再度ログインしてお試しください"
        case .authorizationError:
            return "アカウントの権限を確認してください"
        case .requestNotFound:
            return "修正依頼が存在するか確認してください"
        case .requestLimitExceeded:
            return "しばらく待ってから再度お試しください"
        case .duplicateRequest:
            return "既存の修正依頼を確認してください"
        case .serverError:
            return "しばらく待ってから再度お試しください"
        case .unknown:
            return "再度お試しいただくか、サポートにお問い合わせください"
        }
    }
    
    var isRetryable: Bool {
        switch self {
        case .networkError, .serverError:
            return true
        case .invalidRequest, .authenticationError, .authorizationError, 
             .requestNotFound, .requestLimitExceeded, .duplicateRequest, .unknown:
            return false
        }
    }
}