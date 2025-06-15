//
//  SubmitProfileCorrectionUseCaseError.swift
//  IlluMefy
//
//  Created by Assistant on 2025/06/14.
//

import Foundation

/// プロフィール修正依頼送信ユースケースエラー
enum SubmitProfileCorrectionUseCaseError: Error, UseCaseErrorProtocol, Equatable {
    
    // MARK: - Error Cases
    
    /// バリデーションエラー
    case validationError(String)
    
    /// ネットワークエラー
    case networkError
    
    /// 認証エラー
    case authenticationError
    
    /// 権限エラー
    case authorizationError
    
    /// クリエイターが見つからない
    case creatorNotFound
    
    /// 修正依頼の上限に達した
    case requestLimitExceeded
    
    /// 重複した修正依頼
    case duplicateRequest
    
    /// サーバーエラー
    case serverError
    
    /// 不明なエラー
    case unknown(String)
    
    // MARK: - UseCaseErrorProtocol
    
    var code: Int {
        switch self {
        case .validationError:
            return 3001
        case .networkError:
            return 3002
        case .authenticationError:
            return 3003
        case .authorizationError:
            return 3004
        case .creatorNotFound:
            return 3005
        case .requestLimitExceeded:
            return 3006
        case .duplicateRequest:
            return 3007
        case .serverError:
            return 3008
        case .unknown:
            return 3999
        }
    }
    
    var message: String {
        return errorDescription ?? "不明なエラーが発生しました"
    }
    
    var underlyingError: Error? {
        switch self {
        case .unknown(let message):
            return NSError(domain: "SubmitProfileCorrectionUseCaseError", code: code, userInfo: [NSLocalizedDescriptionKey: message])
        default:
            return nil
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .validationError(let message):
            return message
        case .networkError:
            return "ネットワーク接続を確認してください"
        case .authenticationError:
            return "認証に失敗しました"
        case .authorizationError:
            return "権限がありません"
        case .creatorNotFound:
            return "指定されたクリエイターが見つかりません"
        case .requestLimitExceeded:
            return "修正依頼の上限に達しました"
        case .duplicateRequest:
            return "同じ修正依頼が既に送信されています"
        case .serverError:
            return "サーバーエラーが発生しました"
        case .unknown(let message):
            return "予期しないエラーが発生しました: \(message)"
        }
    }
    
    var failureReason: String? {
        switch self {
        case .validationError:
            return "入力内容に問題があります"
        case .networkError:
            return "ネットワーク接続に失敗しました"
        case .authenticationError:
            return "認証に失敗しました"
        case .authorizationError:
            return "権限が不足しています"
        case .creatorNotFound:
            return "クリエイターが見つかりませんでした"
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
        case .validationError:
            return "入力内容を確認して再度お試しください"
        case .networkError:
            return "インターネット接続を確認して再度お試しください"
        case .authenticationError:
            return "再度ログインしてお試しください"
        case .authorizationError:
            return "アカウントの権限を確認してください"
        case .creatorNotFound:
            return "クリエイターが存在するか確認してください"
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
        case .validationError, .authenticationError, .authorizationError, 
             .creatorNotFound, .requestLimitExceeded, .duplicateRequest, .unknown:
            return false
        }
    }
}